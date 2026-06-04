import os
import glob
import pandas as pd
from sqlalchemy import create_engine, text
import unicodedata
import re
from dotenv import load_dotenv
import datetime
import shutil
import sys

# Ensure console output handles UTF-8 (best effort)
try:
    if sys.stdout.encoding != 'utf-8':
        sys.stdout.reconfigure(encoding='utf-8')
except Exception:
    pass

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

def extract_time_from_filename(filename):
    # Dữ+liệu+Dịch+vụ+Hiển+thị+Sản+Phẩm-184713190-10_05_2026-16_05_2026.csv
    # Extract the first date from pattern DD_MM_YYYY
    match = re.search(r'(\d{2})_(\d{2})_(\d{4})', filename)
    if match:
        # e.g., 10_05_2026 -> 2026-05-10 00:00:00
        return f"{match.group(3)}-{match.group(2)}-{match.group(1)} 00:00:00"
    return datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def safe_print(message):
    try:
        print(message)
    except UnicodeEncodeError:
        # Strip diacritics for terminal display in case of cp1252 restriction
        clean_msg = unicodedata.normalize('NFKD', message).encode('ASCII', 'ignore').decode('utf-8')
        print(clean_msg)

def main():
    load_dotenv()
    
    DB_USER = os.getenv('DB_USER', 'postgres')
    DB_PASS = os.getenv('DB_PASS', '123456')
    DB_HOST = os.getenv('DB_HOST', 'localhost')
    DB_PORT = os.getenv('DB_PORT', '5432')
    DB_NAME = os.getenv('DB_NAME', 'watch_biz')
    
    SCHEMA_NAME = 'root_data'
    TABLE_NAME = 'campaign_performance_csv'

    BASE_DIR = os.path.dirname(__file__)
    DATA_DIR = os.path.join(BASE_DIR, 'raw_data', 'data_campaign_performance')
    DONE_DIR = os.path.join(BASE_DIR, 'done', 'data_campaign_performance')

    connection_string = f"postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}?sslmode=disable"
    
    safe_print(f"Connecting to database {DB_NAME} on {DB_HOST}...")
    try:
        engine = create_engine(connection_string)
        with engine.connect() as conn:
            conn.execute(text(f'CREATE SCHEMA IF NOT EXISTS "{SCHEMA_NAME}";'))
            conn.commit()
        safe_print("Connection successful!\n")
    except Exception as e:
        safe_print(f"Database connection error: {e}")
        return

    if not os.path.exists(DATA_DIR):
        safe_print(f"Directory not found: {DATA_DIR}. Creating it...")
        os.makedirs(DATA_DIR)

    csv_files = glob.glob(os.path.join(DATA_DIR, '*.csv'))
    
    if not csv_files:
        safe_print(f"No .csv files found in {DATA_DIR}")
        return
        
    # Sort files so campaign_performance.csv (old data) imports first if both exist
    csv_files.sort(key=lambda x: 0 if os.path.basename(x) == "campaign_performance.csv" else 1)

    safe_print(f"Found {len(csv_files)} files. Starting data import...\n")

    total_rows = 0
    success_count = 0
    failed_count = 0
    
    log_file_path = os.path.join(BASE_DIR, 'log.txt')
    log_file = open(log_file_path, 'a', encoding='utf-8')
    log_file.write(f"\n--- Ads Campaign Import: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} ---\n")

    for idx, file_path in enumerate(csv_files, 1):
        filename = os.path.basename(file_path)
        safe_print(f"Processing [{idx}/{len(csv_files)}]: {filename}")
        
        try:
            # Distinguish file types
            if filename == "campaign_performance.csv":
                # Old data format (1 row of headers, no skipped rows)
                df = pd.read_csv(file_path, encoding='utf-8')
                df = df.replace('-', None)
                
                # Map old columns to new columns
                rename_map = {}
                for col in df.columns:
                    if col == 'campagin_key_id':
                        rename_map[col] = 'campaign_key_id'
                    elif col == 'product_name':
                        rename_map[col] = 'ten_san_pham'
                    elif col == 'date_time':
                        rename_map[col] = 'thoi_gian'
                df.rename(columns=rename_map, inplace=True)
                
                # Parse thoi_gian as datetime timestamp
                df['thoi_gian'] = pd.to_datetime(df['thoi_gian'], errors='coerce')
                
            else:
                # New Shopee CSV export format (6 rows of description, 1 blank row)
                df = pd.read_csv(file_path, encoding='utf-8', skiprows=7)
                df = df.replace('-', None)
                
                cols = list(df.columns)
                # 1st column -> campaign_key_id
                cols[0] = 'campaign_key_id'
                df[df.columns[0]] = 5
                
                # 3rd column (Mã sản phẩm) -> thoi_gian (timestamp parsed from filename)
                if len(cols) > 2:
                    cols[2] = 'thoi_gian'
                    thoi_gian_str = extract_time_from_filename(filename)
                    df[df.columns[2]] = pd.to_datetime(thoi_gian_str)
                    
                df.columns = cols

            # Clean % columns and numeric values for both formats
            for col in df.columns:
                if df[col].dtype == 'object':
                    if df[col].astype(str).str.contains('%').any():
                        df[col] = df[col].astype(str).str.replace('%', '', regex=False).str.replace(',', '.', regex=False)
                        df[col] = pd.to_numeric(df[col], errors='coerce') / 100

            # Clean all column names
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
            
            # Remove rows where ten_san_pham is 'Shop GMV Max'
            if 'ten_san_pham' in df.columns:
                df = df[df['ten_san_pham'].astype(str).str.strip() != 'Shop GMV Max']
            
            # Nạp vào database với if_exists='append' (giữ cũ, thêm mới)
            df.to_sql(TABLE_NAME, 
                      engine, 
                      schema=SCHEMA_NAME, 
                      if_exists='append', 
                      index=False,
                      chunksize=1000)
            
            num_rows = len(df)
            total_rows += num_rows
            success_count += 1
            safe_print(f"  -> Successfully imported {num_rows} rows.")
            log_file.write(f"THÀNH CÔNG: {filename} - {num_rows} records\n")
            
            # Move to DONE_DIR (with try-except to avoid crash if file is locked)
            try:
                if not os.path.exists(DONE_DIR):
                    os.makedirs(DONE_DIR)
                shutil.move(file_path, os.path.join(DONE_DIR, filename))
                safe_print(f"  -> Moved file to {DONE_DIR}")
            except Exception as move_err:
                safe_print(f"  -> Warning: Could not move file {filename} (probably open in Excel): {move_err}")
                log_file.write(f"CẢNH BÁO: Không thể di chuyển file {filename} - {move_err}\n")
            
        except Exception as e:
            failed_count += 1
            safe_print(f"  -> ERROR processing file {filename}: {e}")
            log_file.write(f"THẤT BẠI: {filename} - Lỗi: {str(e)}\n")

    summary_msg = f"\nCompleted! Total rows imported: {total_rows} | Success: {success_count} files | Failed: {failed_count} files"
    safe_print(summary_msg)
    log_file.write(f"TỔNG KẾT: {success_count} file thành công (Tổng cộng {total_rows} records) | {failed_count} file thất bại\n")
    log_file.write("-" * 60 + "\n")
    log_file.close()

if __name__ == "__main__":
    main()
