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
    
    # Map Vietnamese characters to ASCII
    vietnamese_map = {
        'à': 'a', 'á': 'a', 'ả': 'a', 'ã': 'a', 'ạ': 'a',
        'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a',
        'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a',
        'đ': 'd',
        'è': 'e', 'é': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ẹ': 'e',
        'ê': 'e', 'ề': 'e', 'ế': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e',
        'ì': 'i', 'í': 'i', 'ỉ': 'i', 'ĩ': 'i', 'ị': 'i',
        'ò': 'o', 'ó': 'o', 'ỏ': 'o', 'õ': 'o', 'ọ': 'o',
        'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o',
        'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ở': 'o', 'ỡ': 'o', 'ợ': 'o',
        'ù': 'u', 'ú': 'u', 'ủ': 'u', 'ũ': 'u', 'ụ': 'u',
        'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u',
        'ỳ': 'y', 'ý': 'y', 'ỷ': 'y', 'ỹ': 'y', 'ỵ': 'y',
    }
    
    col_name = col_name.lower()
    for vn_char, ascii_char in vietnamese_map.items():
        col_name = col_name.replace(vn_char, ascii_char)
        
    col_name = unicodedata.normalize('NFKD', col_name).encode('ASCII', 'ignore').decode('utf-8')
    col_name = re.sub(r'[^a-z0-9]', '_', col_name)
    col_name = re.sub(r'_+', '_', col_name).strip('_')
    return col_name

def extract_nam_thang_from_filename(filename):
    # Pattern: DD_MM_YYYY-DD_MM_YYYY (e.g., 01_02_2026-28_02_2026)
    m = re.search(r'(\d{2})_(\d{2})_(\d{4})-(\d{2})_(\d{2})_(\d{4})', filename)
    if m:
        # Returns YYYY-MM-DD 00:00:00 (timestamp format using start date)
        return f"{m.group(3)}-{m.group(2)}-{m.group(1)} 00:00:00"
    
    # Another pattern for order exports: "Order.all.20260501_20260514.xlsx" or "orders_20260201..."
    m2 = re.search(r'(20\d{2})(\d{2})(\d{2})', filename)
    if m2:
        return f"{m2.group(1)}-{m2.group(2)}-{m2.group(3)} 00:00:00"
    return None

def get_dataframe(file_path):
    if file_path.lower().endswith('.csv'):
        skip_rows = 0
        import csv
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            reader = csv.reader(f)
            for i, row in enumerate(reader):
                if sum(1 for cell in row if cell.strip() != '') > 5:
                    skip_rows = i
                    break
        return pd.read_csv(file_path, skiprows=skip_rows)
    else:
        return pd.read_excel(file_path)

def main():
    load_dotenv()
    
    DB_USER = os.getenv('DB_USER', 'postgres')
    DB_PASS = os.getenv('DB_PASS', '123456')
    DB_HOST = os.getenv('DB_HOST', 'localhost')
    DB_PORT = os.getenv('DB_PORT', '5432')
    DB_NAME = os.getenv('DB_NAME', 'watch_biz')
    SCHEMA_NAME = 'root_data'
    TABLE_NAME = 'orders'

    BASE_DIR = os.path.dirname(__file__)
    DATA_DIR = os.path.join(BASE_DIR, 'raw_data', 'DONHANG')

    connection_string = f"postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}?sslmode=disable"
    
    print(f"Connecting to database {DB_NAME} on {DB_HOST}...")
    try:
        engine = create_engine(connection_string)
        # Check if table exists to decide on duplicate checking and get existing columns
        existing_order_ids = set()
        db_columns = set()
        try:
            with engine.connect() as conn:
                result = conn.execute(text(f'SELECT "ma_don_hang" FROM "{SCHEMA_NAME}"."{TABLE_NAME}"'))
                existing_order_ids = {row[0] for row in result}
                print(f"Found {len(existing_order_ids)} existing orders in database.")
                
                col_res = conn.execute(text(f"SELECT column_name FROM information_schema.columns WHERE table_schema = '{SCHEMA_NAME}' AND table_name = '{TABLE_NAME}'"))
                db_columns = {row[0] for row in col_res}
                print(f"Found {len(db_columns)} columns in database table.")
        except Exception:
            print("Table does not exist yet. It will be created during the first import.")

        print("Connection successful!\n")
    except Exception as e:
        print(f"Database connection error: {e}")
        return

    excel_files = glob.glob(os.path.join(DATA_DIR, '*.xlsx'))
    csv_files = glob.glob(os.path.join(DATA_DIR, '*.csv'))
    data_files = excel_files + csv_files
    
    if not data_files:
        print(f"No .xlsx or .csv files found in {DATA_DIR}")
        return
        
    print(f"Found {len(data_files)} files. Starting data import...\n")

    total_rows = 0
    success_count = 0
    failed_count = 0
    
    log_file_path = os.path.join(os.path.dirname(__file__), 'log.txt')
    log_file = open(log_file_path, 'a', encoding='utf-8')
    log_file.write(f"\n--- Phiên import: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} ---\n")

    for idx, file_path in enumerate(data_files, 1):
        filename = os.path.basename(file_path)
        safe_filename = filename.encode('ascii', 'ignore').decode('ascii')
        print(f"Processing [{idx}/{len(data_files)}]: {safe_filename}")
        
        try:
            df = get_dataframe(file_path)
            
            # Clean column names first to identify 'ma_don_hang'
            cleaned_cols = [clean_column_name(col) for col in df.columns]
            
            # Map "phí xử lý giao dịch" (which cleans to "phi_xu_ly_giao_dich") to "phi_thanh_toan"
            cleaned_cols = ['phi_thanh_toan' if col == 'phi_xu_ly_giao_dich' else col for col in cleaned_cols]
            
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


                
            # Convert date columns to proper datetime for DBeaver compatibility
            for col in df.columns:
                col_lower = col.lower()
                if any(x in col_lower for x in ['ngay', 'time', 'date', 'gio']):
                    try:
                        df[col] = pd.to_datetime(df[col], errors='coerce')
                    except Exception:
                        pass

            # Check for duplicates if table exists
            if existing_order_ids and 'ma_don_hang' in df.columns:
                initial_count = len(df)
                df = df[~df['ma_don_hang'].astype(str).isin(existing_order_ids)]
                new_count = len(df)
                if initial_count > new_count:
                    print(f"  -> Filtered out {initial_count - new_count} duplicate orders.")
            
            if df.empty:
                print(f"  -> All orders in {filename} already exist in database. Skipping.")
                # Still move to PROCESSED
            else:
                thoi_gian = extract_nam_thang_from_filename(filename)
                if thoi_gian:
                    df.insert(0, 'thoi_gian', pd.to_datetime(thoi_gian))
                
                if db_columns:
                    # Keep only columns that exist in the database table
                    df = df[[col for col in df.columns if col in db_columns]]
                
                df.to_sql(TABLE_NAME, 
                          engine, 
                          schema=SCHEMA_NAME, 
                          if_exists='append', 
                          index=False,
                          chunksize=1000)
                
                num_rows = len(df)
                total_rows += num_rows
                success_count += 1
                print(f"  -> Successfully imported {num_rows} new rows.")
                log_file.write(f"THANH CONG: {filename} - {num_rows} records\n")

            # Move file to PROCESSED folder
            processed_dir = os.path.join(DATA_DIR, 'PROCESSED')
            if not os.path.exists(processed_dir):
                os.makedirs(processed_dir)
            
            shutil.move(file_path, os.path.join(processed_dir, filename))
            print(f"  -> Moved file to {os.path.join('PROCESSED', filename)}")
            
        except Exception as e:
            failed_count += 1
            safe_e = str(e).encode('ascii', 'ignore').decode('ascii')
            print(f"  -> ERROR processing file {safe_filename}: {safe_e}")
            log_file.write(f"THAT BAI: {safe_filename} - Loi: {safe_e}\n")

    summary_msg = f"\nCompleted! Total rows imported: {total_rows} | Success: {success_count} files | Failed: {failed_count} files"
    print(summary_msg)
    log_file.write(f"TỔNG KẾT: {success_count} file thành công (Tổng cộng {total_rows} records) | {failed_count} file thất bại\n")
    log_file.write("-" * 60 + "\n")
    log_file.close()

if __name__ == "__main__":
    main()
