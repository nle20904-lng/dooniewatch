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
        return f"{m.group(3)}-{m.group(2)}-{m.group(1)} 00:00:00"
    
    # Another pattern for order exports: "Order.all.20260501_20260514.xlsx"
    m2 = re.search(r'(20\d{2})(\d{2})(\d{2})', filename)
    if m2:
        return f"{m2.group(1)}-{m2.group(2)}-{m2.group(3)} 00:00:00"
    return None

def clean_numeric_value(val):
    if pd.isna(val) or val is None:
        return None
    if isinstance(val, (int, float)):
        return val
    
    s = str(val).strip()
    if s == '-' or s == '':
        return None
        
    # Remove currency and other non-numeric symbols
    s = s.replace('₫', '').replace('đ', '').replace('VND', '').replace('vnd', '').strip()
    s = s.replace('\xa0', '').replace(' ', '')
    
    # Handle thousand and decimal separators (Vietnamese standard dot/comma vs English)
    if ',' in s and '.' in s:
        if s.find(',') > s.find('.'):
            # English standard: 1,234,567.89
            s = s.replace(',', '')
        else:
            # Vietnamese standard: 1.234.567,89
            s = s.replace('.', '').replace(',', '.')
    elif ',' in s:
        # Only commas: check if it represents a decimal part (usually 2 digits, e.g. 12,50)
        parts = s.split(',')
        if len(parts[-1]) == 2:
            s = s.replace(',', '.')
        else:
            s = s.replace(',', '')
    elif '.' in s:
        # Only dots: in Vietnamese billing, e.g. "12.000" means 12000, so remove the dot if followed by 3 digits
        parts = s.split('.')
        if len(parts) == 2 and len(parts[1]) == 3:
            s = s.replace('.', '')
            
    try:
        return float(s)
    except ValueError:
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
    
    DB_USER = os.getenv('DB_USER', 'hnv_lenguyen')
    DB_PASS = os.getenv('DB_PASS', 'gtE04Wx1')
    DB_HOST = os.getenv('DB_HOST', '172.30.2.38')
    DB_PORT = os.getenv('DB_PORT', '5432')
    DB_NAME = os.getenv('DB_NAME', 'watch_biz')
    SCHEMA_NAME = os.getenv('SCHEMA_NAME', 'root_data')
    TABLE_NAME = os.getenv('TABLE_NAME', 'order_all')
    DATA_DIR = os.getenv('DATA_DIR', os.path.join(os.path.dirname(__file__), 'raw_data', 'update'))

    # Auto-create data directories if not present
    if not os.path.exists(DATA_DIR):
        os.makedirs(DATA_DIR)
        print(f"Created input directory: {DATA_DIR}")
        
    done_dir = os.path.join(DATA_DIR, 'done')
    if not os.path.exists(done_dir):
        os.makedirs(done_dir)
        print(f"Created archive directory: {done_dir}")

    connection_string = f"postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}?sslmode=disable"
    
    print(f"Connecting to database {DB_NAME} on {DB_HOST}...")
    try:
        engine = create_engine(connection_string)
        
        # Ensure schema exists
        with engine.connect() as conn:
            conn.execute(text(f'CREATE SCHEMA IF NOT EXISTS "{SCHEMA_NAME}";'))
            conn.commit()
            
        print("Recreating table order_all using the exact requested DDL...")
        # Explicit DDL provided by the user
        ddl_sql = f"""
        DROP TABLE IF EXISTS "{SCHEMA_NAME}"."{TABLE_NAME}" CASCADE;
        CREATE TABLE "{SCHEMA_NAME}"."{TABLE_NAME}" (
            ma_don_hang text NULL,
            ma_kien_hang text NULL,
            ngay_dat_hang timestamp NULL,
            trang_thai_don_hang text NULL,
            san_pham_ban_chay text NULL,
            ly_do_huy text NULL,
            nhan_xet_tu_nguoi_mua text NULL,
            ma_van_don text NULL,
            don_vi_van_chuyen text NULL,
            phuong_thuc_giao_hang text NULL,
            loai_don_hang text NULL,
            ngay_giao_hang_du_kien timestamp NULL,
            ngay_gui_hang timestamp NULL,
            thoi_gian_giao_hang timestamp NULL,
            trang_thai_tra_hang_hoan_tien text NULL,
            sku_san_pham text NULL,
            ten_san_pham text NULL,
            can_nang_san_pham text NULL,
            tong_can_nang text NULL,
            sku_phan_loai_hang text NULL,
            ten_phan_loai_hang text NULL,
            gia_goc numeric NULL,
            nguoi_ban_tro_gia numeric NULL,
            duoc_shopee_tro_gia numeric NULL,
            tong_so_tien_duoc_nguoi_ban_tro_gia numeric NULL,
            gia_uu_dai numeric NULL,
            so_luong numeric NULL,
            so_luong_san_pham_duoc_hoan_tra numeric NULL,
            tong_so_tien_nguoi_mua_thanh_toan numeric NULL,
            tong_gia_tri_don_hang_vnd numeric NULL,
            ma_giam_gia_cua_shop text NULL,
            hoan_xu text NULL,
            ma_giam_gia_cua_shopee text NULL,
            chi_tieu_combo_khuyen_mai text NULL,
            giam_gia_tu_combo_shopee text NULL,
            giam_gia_tu_combo_cua_shop text NULL,
            shopee_xu_duoc_hoan text NULL,
            so_tien_duoc_giam_khi_thanh_toan_bang_the_ghi_no text NULL,
            trade_in_discount text NULL,
            trade_in_bonus text NULL,
            phi_van_chuyen_du_kien text NULL,
            trade_in_bonus_by_seller text NULL,
            phi_van_chuyen_ma_nguoi_mua_tra text NULL,
            phi_van_chuyen_tai_tro_boi_shopee_du_kien text NULL,
            phi_van_chuyen_tra_hang_don_tra_hang_hoan_tien text NULL,
            tong_so_tien_nguoi_mua_thanh_toan_1 text NULL,
            thoi_gian_hoan_thanh_don_hang timestamp NULL,
            thoi_gian_don_hang_duoc_thanh_toan text NULL,
            phuong_thuc_thanh_toan text NULL,
            phi_co_dinh numeric NULL,
            phi_dich_vu numeric NULL,
            phi_thanh_toan numeric NULL,
            tien_ky_quy text NULL,
            nguoi_mua varchar NULL,
            ten_nguoi_nhan varchar NULL,
            so_dien_thoai text NULL,
            tinh_thanh_pho varchar NULL,
            tp_quan_huyen varchar NULL,
            quan varchar NULL,
            dia_chi_nhan_hang text NULL,
            quoc_gia text NULL,
            ghi_chu text NULL,
            thoi_gian timestamp NULL
        );
        """
        with engine.connect() as conn:
            conn.execute(text(ddl_sql))
            conn.commit()
        print("Table order_all dropped and recreated successfully with the exact request DDL.")
        
        # Get column names of the recreated table
        db_columns = set()
        with engine.connect() as conn:
            col_res = conn.execute(text(
                f"SELECT column_name FROM information_schema.columns WHERE table_schema = '{SCHEMA_NAME}' AND table_name = '{TABLE_NAME}'"
            ))
            db_columns = {row[0] for row in col_res}
            print(f"Table prepared with {len(db_columns)} columns.\n")
            
    except Exception as e:
        print(f"Database setup error: {e}")
        return

    # Find raw files to process
    excel_files = glob.glob(os.path.join(DATA_DIR, '*.xlsx'))
    csv_files = glob.glob(os.path.join(DATA_DIR, '*.csv'))
    data_files = excel_files + csv_files
    data_files.sort()
    
    if not data_files:
        print(f"No .xlsx or .csv files found in {DATA_DIR} to import.")
        return
        
    print(f"Found {len(data_files)} file(s). Starting data import...\n")

    total_rows = 0
    success_count = 0
    failed_count = 0
    
    log_file_path = os.path.join(os.path.dirname(__file__), 'log.txt')
    log_file = open(log_file_path, 'a', encoding='utf-8')
    log_file.write(f"\n--- Order All Import Session (Explicit DDL): {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} ---\n")

    # Precise column types matching the DDL
    numeric_columns = {
        'gia_goc', 'nguoi_ban_tro_gia', 'duoc_shopee_tro_gia',
        'tong_so_tien_duoc_nguoi_ban_tro_gia', 'gia_uu_dai', 'so_luong',
        'so_luong_san_pham_duoc_hoan_tra', 'tong_so_tien_nguoi_mua_thanh_toan',
        'tong_gia_tri_don_hang_vnd', 'phi_co_dinh', 'phi_dich_vu', 'phi_thanh_toan'
    }

    timestamp_columns = {
        'ngay_dat_hang', 'ngay_giao_hang_du_kien', 'ngay_gui_hang',
        'thoi_gian_giao_hang', 'thoi_gian_hoan_thanh_don_hang', 'thoi_gian'
    }

    for idx, file_path in enumerate(data_files, 1):
        filename = os.path.basename(file_path)
        print(f"Processing [{idx}/{len(data_files)}]: {filename}")
        
        try:
            df = get_dataframe(file_path)
            
            # Clean column names
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

            # Parse and clean % columns first
            for col in df.columns:
                if df[col].dtype == 'object':
                    try:
                        if df[col].astype(str).str.contains('%').any():
                            df[col] = df[col].astype(str).str.replace('%', '', regex=False).str.replace(',', '.', regex=False)
                            df[col] = pd.to_numeric(df[col], errors='coerce') / 100
                    except Exception:
                        pass

            # Convert date columns to proper datetime matching DDL
            for col in df.columns:
                if col in timestamp_columns:
                    try:
                        df[col] = pd.to_datetime(df[col], errors='coerce')
                    except Exception:
                        pass

            # Convert numeric columns to proper numbers matching DDL
            for col in df.columns:
                if col in numeric_columns:
                    try:
                        if not pd.api.types.is_numeric_dtype(df[col]):
                            df[col] = df[col].apply(clean_numeric_value)
                            df[col] = pd.to_numeric(df[col], errors='coerce')
                    except Exception:
                        pass

            # Add thoi_gian timestamp from filename or current time
            thoi_gian_str = extract_nam_thang_from_filename(filename)
            if thoi_gian_str:
                df.insert(0, 'thoi_gian', pd.to_datetime(thoi_gian_str))
            else:
                df.insert(0, 'thoi_gian', pd.to_datetime(datetime.datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)))

            # If db_columns is not empty, keep only existing columns in table
            if db_columns:
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
            log_file.write(f"THANH CONG: {filename} - {num_rows} records\n")
            
            # Archive file to done folder
            try:
                shutil.move(file_path, os.path.join(done_dir, filename))
                print(f"  -> Moved file to {os.path.join(DATA_DIR, 'done', filename)}")
            except Exception as move_err:
                print(f"  -> Warning: Could not archive file {filename} (might be open elsewhere): {move_err}")
                log_file.write(f"CANH BAO: Khong the di chuyen file {filename} - {move_err}\n")
                
        except Exception as e:
            failed_count += 1
            safe_e = str(e).encode('ascii', errors='ignore').decode('ascii')
            print(f"  -> ERROR importing file {filename}: {safe_e}")
            log_file.write(f"THAT BAI: {filename} - Loi: {str(e)}\n")

    summary_msg = f"\nCompleted! Total rows imported: {total_rows} | Success: {success_count} file(s) | Failed: {failed_count} file(s)"
    print(summary_msg)
    log_file.write(f"TONG KET: {success_count} file thanh cong (Tong cong {total_rows} records) | {failed_count} file that bai\n")
    log_file.write("-" * 60 + "\n")
    log_file.close()

if __name__ == "__main__":
    main()
