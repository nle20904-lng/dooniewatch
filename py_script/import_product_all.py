import os
import glob
import pandas as pd
from sqlalchemy import create_engine, text
import unicodedata
import re
from dotenv import load_dotenv
import datetime
import shutil

def clean_column_name(col_name):
    if not isinstance(col_name, str):
        col_name = str(col_name)
    # Remove Vietnamese accents
    col_name = unicodedata.normalize('NFKD', col_name).encode('ASCII', 'ignore').decode('utf-8')
    col_name = col_name.lower()
    # Replace non-alphanumeric with underscore
    col_name = re.sub(r'[^a-z0-9]', '_', col_name)
    # Remove multiple underscores
    col_name = re.sub(r'_+', '_', col_name).strip('_')
    return col_name

def extract_timestamp_from_filename(filename):
    # Pattern 1: YYYYMMDD (e.g. 20240401)
    m1 = re.search(r'(\d{4})(\d{2})(\d{2})', filename)
    if m1:
        return f"{m1.group(1)}-{m1.group(2)}-{m1.group(3)} 00:00:00"
    
    # Pattern 2: DD_MM_YYYY (e.g. 10_05_2026)
    m2 = re.search(r'(\d{2})_(\d{2})_(\d{4})', filename)
    if m2:
        return f"{m2.group(3)}-{m2.group(2)}-{m2.group(1)} 00:00:00"
    return None

def get_dataframe(file_path):
    if file_path.lower().endswith('.csv'):
        # Shopee CSVs often have some header lines, let's try to find the real header
        import csv
        skip_rows = 0
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            reader = csv.reader(f)
            for i, row in enumerate(reader):
                if sum(1 for cell in row if cell.strip() != '') > 5:
                    skip_rows = i
                    break
        return pd.read_csv(file_path, skiprows=skip_rows)
    else:
        # For Excel files
        return pd.read_excel(file_path)

def main():
    load_dotenv()
    
    DB_USER = os.getenv('DB_USER', 'postgres')
    DB_PASS = os.getenv('DB_PASS', '123456')
    DB_HOST = os.getenv('DB_HOST', 'localhost')
    DB_PORT = os.getenv('DB_PORT', '5432')
    DB_NAME = os.getenv('DB_NAME', 'watch_biz')
    SCHEMA_NAME = 'root_data'
    TABLE_NAME = 'product_all'

    BASE_DIR = os.path.dirname(__file__)
    DATA_DIR = os.path.join(BASE_DIR, 'raw_data', 'product_all')

    connection_string = f"postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}?sslmode=disable"
    
    print(f"Connecting to database {DB_NAME} on {DB_HOST}...")
    try:
        engine = create_engine(connection_string)
        # Check if schema exists, create if not
        db_columns = set()
        with engine.connect() as conn:
            conn.execute(text(f'CREATE SCHEMA IF NOT EXISTS "{SCHEMA_NAME}";'))
            
            # Truncate old data
            try:
                conn.execute(text(f'TRUNCATE TABLE "{SCHEMA_NAME}"."{TABLE_NAME}";'))
                print(f"Truncated old data in {SCHEMA_NAME}.{TABLE_NAME}")
            except Exception:
                # Table might not exist yet
                pass
            conn.commit()

            try:
                col_res = conn.execute(text(f"SELECT column_name FROM information_schema.columns WHERE table_schema = '{SCHEMA_NAME}' AND table_name = '{TABLE_NAME}'"))
                db_columns = {row[0] for row in col_res}
                if db_columns:
                    print(f"Found {len(db_columns)} columns in database table.")
            except Exception:
                pass
        print("Connection successful!\n")
    except Exception as e:
        print(f"Database connection error: {e}")
        return

    # Find all Excel and CSV files
    excel_files = glob.glob(os.path.join(DATA_DIR, '*.xlsx'))
    csv_files = glob.glob(os.path.join(DATA_DIR, '*.csv'))
    data_files = excel_files + csv_files
    
    # Sort files by name to import in order
    data_files.sort()

    if not data_files:
        print(f"No .xlsx or .csv files found in {DATA_DIR}")
        return
        
    print(f"Found {len(data_files)} files. Starting data import...\n")

    total_rows = 0
    success_count = 0
    failed_count = 0
    
    log_file_path = os.path.join(os.path.dirname(__file__), 'log.txt')
    log_file = open(log_file_path, 'a', encoding='utf-8')
    log_file.write(f"\n--- Product All Import: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} ---\n")

    for idx, file_path in enumerate(data_files, 1):
        filename = os.path.basename(file_path)
        print(f"Processing [{idx}/{len(data_files)}]: {filename}")
        
        try:
            df = get_dataframe(file_path)
            
            # Extract timestamp and add column
            thoi_gian_str = extract_timestamp_from_filename(filename)
            if thoi_gian_str:
                df.insert(0, 'thoi_gian', pd.to_datetime(thoi_gian_str))
            else:
                # Fallback if no date in filename
                df.insert(0, 'thoi_gian', pd.to_datetime(datetime.datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)))
            
            # Clean column names
            cleaned_cols = [clean_column_name(col) for col in df.columns]
            
            # Deduplicate column names
            seen = {}
            dedup_cols = []
            for col in cleaned_cols:
                if col in seen:
                    seen[col] += 1
                    dedup_cols.append(f"{col}_{seen[col]}")
                else:
                    seen[col] = 0
                    dedup_cols.append(col)
            
            df.columns = dedup_cols
            
            if db_columns:
                # Keep only columns that exist in the database table
                df = df[[col for col in df.columns if col in db_columns]]
            
            # Import to database
            df.to_sql(TABLE_NAME, 
                      engine, 
                      schema=SCHEMA_NAME, 
                      if_exists='append', 
                      index=False,
                      chunksize=1000)
            
            num_rows = len(df)
            total_rows += num_rows
            success_count += 1
            print(f"  -> Successfully imported {num_rows} rows.")
            log_file.write(f"THÀNH CÔNG: {filename} - {num_rows} records\n")
            
            # Move file to done folder
            try:
                done_dir = os.path.join(DATA_DIR, 'done')
                if not os.path.exists(done_dir):
                    os.makedirs(done_dir)
                shutil.move(file_path, os.path.join(done_dir, filename))
                print(f"  -> Moved file to {os.path.join('done', filename)}")
            except Exception as move_err:
                print(f"  -> Warning: Could not move file {filename} (probably open in Excel): {move_err}")
                log_file.write(f"CẢNH BÁO: Không thể di chuyển file {filename} - {move_err}\n")
            
        except Exception as e:
            failed_count += 1
            safe_e = str(e).encode('ascii', errors='ignore').decode('ascii')
            print(f"  -> ERROR processing file {filename}: {safe_e}")
            log_file.write(f"THẤT BẠI: {filename} - Lỗi: {str(e)}\n")

    summary_msg = f"\nCompleted! Total rows imported: {total_rows} | Success: {success_count} files | Failed: {failed_count} files"
    print(summary_msg)
    log_file.write(f"TỔNG KẾT: {success_count} file thành công (Tổng cộng {total_rows} records) | {failed_count} file thất bại\n")
    log_file.write("-" * 60 + "\n")
    log_file.close()

if __name__ == "__main__":
    main()
