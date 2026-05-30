SELECT version();
CREATE OR REPLACE PROCEDURE stg.prc_update_status_fact_txn_orders()
LANGUAGE plpgsql
AS $procedure$
begin
	-- ============================================================
    -- PHẦN 1: Thêm các mã đơn hàng chưa có
    -- ============================================================
    INSERT INTO root_data.orders (
        ma_don_hang, ma_kien_hang, ngay_dat_hang, trang_thai_don_hang,
        san_pham_ban_chay, ly_do_huy, nhan_xet_tu_nguoi_mua, ma_van_don,
        don_vi_van_chuyen, phuong_thuc_giao_hang, loai_don_hang,
        ngay_giao_hang_du_kien, ngay_gui_hang, thoi_gian_giao_hang,
        trang_thai_tra_hang_hoan_tien, sku_san_pham, ten_san_pham,
        can_nang_san_pham, tong_can_nang, sku_phan_loai_hang, ten_phan_loai_hang,
        gia_goc, nguoi_ban_tro_gia, duoc_shopee_tro_gia,
        tong_so_tien_duoc_nguoi_ban_tro_gia, gia_uu_dai, so_luong,
        so_luong_san_pham_duoc_hoan_tra, tong_so_tien_nguoi_mua_thanh_toan,
        tong_gia_tri_don_hang_vnd, ma_giam_gia_cua_shop, hoan_xu,
        ma_giam_gia_cua_shopee, chi_tieu_combo_khuyen_mai,
        giam_gia_tu_combo_shopee, giam_gia_tu_combo_cua_shop,
        shopee_xu_duoc_hoan, so_tien_duoc_giam_khi_thanh_toan_bang_the_ghi_no,
        trade_in_discount, trade_in_bonus, phi_van_chuyen_du_kien,
        trade_in_bonus_by_seller, phi_van_chuyen_ma_nguoi_mua_tra,
        phi_van_chuyen_tai_tro_boi_shopee_du_kien,
        phi_van_chuyen_tra_hang_don_tra_hang_hoan_tien,
        tong_so_tien_nguoi_mua_thanh_toan_1, thoi_gian_hoan_thanh_don_hang,
        thoi_gian_don_hang_duoc_thanh_toan, phuong_thuc_thanh_toan,
        phi_co_dinh, phi_dich_vu, phi_thanh_toan, tien_ky_quy,
        nguoi_mua, ten_nguoi_nhan, so_dien_thoai, tinh_thanh_pho,
        tp_quan_huyen, quan, dia_chi_nhan_hang, quoc_gia, ghi_chu
    )
    SELECT
        src.ma_don_hang, src.ma_kien_hang, src.ngay_dat_hang, src.trang_thai_don_hang,
        src.san_pham_ban_chay, src.ly_do_huy, src.nhan_xet_tu_nguoi_mua, src.ma_van_don,
        src.don_vi_van_chuyen, src.phuong_thuc_giao_hang, src.loai_don_hang,
        src.ngay_giao_hang_du_kien, src.ngay_gui_hang, src.thoi_gian_giao_hang,
        src.trang_thai_tra_hang_hoan_tien, src.sku_san_pham, src.ten_san_pham,
        src.can_nang_san_pham, src.tong_can_nang, src.sku_phan_loai_hang, src.ten_phan_loai_hang,
        src.gia_goc, src.nguoi_ban_tro_gia, src.duoc_shopee_tro_gia,
        src.tong_so_tien_duoc_nguoi_ban_tro_gia, src.gia_uu_dai, src.so_luong,
        src.so_luong_san_pham_duoc_hoan_tra, src.tong_so_tien_nguoi_mua_thanh_toan,
        src.tong_gia_tri_don_hang_vnd, src.ma_giam_gia_cua_shop, src.hoan_xu,
        src.ma_giam_gia_cua_shopee, src.chi_tieu_combo_khuyen_mai,
        src.giam_gia_tu_combo_shopee, src.giam_gia_tu_combo_cua_shop,
        src.shopee_xu_duoc_hoan, src.so_tien_duoc_giam_khi_thanh_toan_bang_the_ghi_no,
        src.trade_in_discount, src.trade_in_bonus, src.phi_van_chuyen_du_kien,
        src.trade_in_bonus_by_seller, src.phi_van_chuyen_ma_nguoi_mua_tra,
        src.phi_van_chuyen_tai_tro_boi_shopee_du_kien,
        src.phi_van_chuyen_tra_hang_don_tra_hang_hoan_tien,
        src.tong_so_tien_nguoi_mua_thanh_toan_1, src.thoi_gian_hoan_thanh_don_hang,
        src.thoi_gian_don_hang_duoc_thanh_toan, src.phuong_thuc_thanh_toan,
        src.phi_co_dinh, src.phi_dich_vu, src.phi_thanh_toan, src.tien_ky_quy,
        src.nguoi_mua, src.ten_nguoi_nhan, src.so_dien_thoai, src.tinh_thanh_pho,
        src.tp_quan_huyen, src.quan, src.dia_chi_nhan_hang, src.quoc_gia, src.ghi_chu
    FROM root_data.order_all src
    LEFT JOIN (
        SELECT DISTINCT ma_don_hang
        FROM root_data.orders
    ) tgt ON src.ma_don_hang = tgt.ma_don_hang
    WHERE tgt.ma_don_hang IS NULL;
   
      -- ============================================================
    -- PHẦN 2: UPDATE tất cả các cột cho các dòng đã tồn tại
    -- ============================================================
    UPDATE root_data.orders tgt
    SET
        ma_kien_hang                                     = src.ma_kien_hang,
        ngay_dat_hang                                    = src.ngay_dat_hang,
        trang_thai_don_hang                              = src.trang_thai_don_hang,
        san_pham_ban_chay                                = src.san_pham_ban_chay,
        ly_do_huy                                        = src.ly_do_huy,
        nhan_xet_tu_nguoi_mua                            = src.nhan_xet_tu_nguoi_mua,
        ma_van_don                                       = src.ma_van_don,
        don_vi_van_chuyen                                = src.don_vi_van_chuyen,
        phuong_thuc_giao_hang                            = src.phuong_thuc_giao_hang,
        loai_don_hang                                    = src.loai_don_hang,
        ngay_giao_hang_du_kien                           = src.ngay_giao_hang_du_kien,
        ngay_gui_hang                                    = src.ngay_gui_hang,
        thoi_gian_giao_hang                              = src.thoi_gian_giao_hang,
        trang_thai_tra_hang_hoan_tien                    = src.trang_thai_tra_hang_hoan_tien,
        ten_san_pham                                     = src.ten_san_pham,
        can_nang_san_pham                                = src.can_nang_san_pham,
        tong_can_nang                                    = src.tong_can_nang,
        ten_phan_loai_hang                               = src.ten_phan_loai_hang,
        gia_goc                                          = src.gia_goc,
        nguoi_ban_tro_gia                                = src.nguoi_ban_tro_gia,
        duoc_shopee_tro_gia                              = src.duoc_shopee_tro_gia,
        tong_so_tien_duoc_nguoi_ban_tro_gia              = src.tong_so_tien_duoc_nguoi_ban_tro_gia,
        gia_uu_dai                                       = src.gia_uu_dai,
        so_luong                                         = src.so_luong,
        so_luong_san_pham_duoc_hoan_tra                  = src.so_luong_san_pham_duoc_hoan_tra,
        tong_so_tien_nguoi_mua_thanh_toan                = src.tong_so_tien_nguoi_mua_thanh_toan,
        tong_gia_tri_don_hang_vnd                        = src.tong_gia_tri_don_hang_vnd,
        ma_giam_gia_cua_shop                             = src.ma_giam_gia_cua_shop,
        hoan_xu                                          = src.hoan_xu,
        ma_giam_gia_cua_shopee                           = src.ma_giam_gia_cua_shopee,
        chi_tieu_combo_khuyen_mai                        = src.chi_tieu_combo_khuyen_mai,
        giam_gia_tu_combo_shopee                         = src.giam_gia_tu_combo_shopee,
        giam_gia_tu_combo_cua_shop                       = src.giam_gia_tu_combo_cua_shop,
        shopee_xu_duoc_hoan                              = src.shopee_xu_duoc_hoan,
        so_tien_duoc_giam_khi_thanh_toan_bang_the_ghi_no = src.so_tien_duoc_giam_khi_thanh_toan_bang_the_ghi_no,
        trade_in_discount                                = src.trade_in_discount,
        trade_in_bonus                                   = src.trade_in_bonus,
        phi_van_chuyen_du_kien                           = src.phi_van_chuyen_du_kien,
        trade_in_bonus_by_seller                         = src.trade_in_bonus_by_seller,
        phi_van_chuyen_ma_nguoi_mua_tra                  = src.phi_van_chuyen_ma_nguoi_mua_tra,
        phi_van_chuyen_tai_tro_boi_shopee_du_kien        = src.phi_van_chuyen_tai_tro_boi_shopee_du_kien,
        phi_van_chuyen_tra_hang_don_tra_hang_hoan_tien   = src.phi_van_chuyen_tra_hang_don_tra_hang_hoan_tien,
        tong_so_tien_nguoi_mua_thanh_toan_1              = src.tong_so_tien_nguoi_mua_thanh_toan_1,
        thoi_gian_hoan_thanh_don_hang                    = src.thoi_gian_hoan_thanh_don_hang,
        thoi_gian_don_hang_duoc_thanh_toan               = src.thoi_gian_don_hang_duoc_thanh_toan,
        phuong_thuc_thanh_toan                           = src.phuong_thuc_thanh_toan,
        phi_co_dinh                                      = src.phi_co_dinh,
        phi_dich_vu                                      = src.phi_dich_vu,
        phi_thanh_toan                                   = src.phi_thanh_toan,
        tien_ky_quy                                      = src.tien_ky_quy,
        nguoi_mua                                        = src.nguoi_mua,
        ten_nguoi_nhan                                   = src.ten_nguoi_nhan,
        so_dien_thoai                                    = src.so_dien_thoai,
        tinh_thanh_pho                                   = src.tinh_thanh_pho,
        tp_quan_huyen                                    = src.tp_quan_huyen,
        quan                                             = src.quan,
        dia_chi_nhan_hang                                = src.dia_chi_nhan_hang,
        quoc_gia                                         = src.quoc_gia,
        ghi_chu                                          = src.ghi_chu
    FROM root_data.order_all src
    WHERE tgt.ma_don_hang       = src.ma_don_hang
      AND tgt.sku_san_pham       = src.sku_san_pham
      AND tgt.sku_phan_loai_hang = src.sku_phan_loai_hang;
     
           -- ============================================================
    -- PHẦN 2: UPDATE tất cả các cột cho các dòng đã tồn tại cho product_performance 
    -- ============================================================
	MERGE INTO root_data.product_performance AS tgt
	USING root_data.product_all AS src
	ON (
	    tgt.thoi_gian    = src.thoi_gian
	    AND tgt.ma_san_pham  = src.ma_san_pham
	    AND tgt.san_pham     = src.san_pham
	)
	WHEN MATCHED
	THEN UPDATE SET
	    tinh_trang_san_pham_hien_tai                                = src.tinh_trang_san_pham_hien_tai,
	    ma_phan_loai_hang                                           = src.ma_phan_loai_hang,
	    ten_phan_loai                                               = src.ten_phan_loai,
	    trang_thai_phan_loai_san_pham_hien_tai                      = src.trang_thai_phan_loai_san_pham_hien_tai,
	    sku_phan_loai                                               = src.sku_phan_loai,
	    sku_san_pham                                                = src.sku_san_pham,
	    doanh_so_on_a_at_vnd                                        = src.doanh_so_on_a_at_vnd,
	    doanh_so_on_a_xac_nhan_vnd                                  = src.doanh_so_on_a_xac_nhan_vnd,
	    luot_xem_san_pham                                           = src.luot_xem_san_pham,
	    luot_nhap_vao_san_pham                                      = src.luot_nhap_vao_san_pham,
	    ctr                                                         = src.ctr,
	    ty_le_chuyen_oi_on_on_a_at                                  = src.ty_le_chuyen_oi_on_on_a_at,
	    ty_le_chuyen_oi_on_on_a_xac_nhan                            = src.ty_le_chuyen_oi_on_on_a_xac_nhan,
	    on_hang_a_at                                                = src.on_hang_a_at,
	    on_a_xac_nhan                                               = src.on_a_xac_nhan,
	    san_pham_on_a_at                                            = src.san_pham_on_a_at,
	    san_pham_on_a_xac_nhan                                      = src.san_pham_on_a_xac_nhan,
	    nguoi_mua_a_at_hang                                         = src.nguoi_mua_a_at_hang,
	    nguoi_mua_co_on_a_xac_nhan                                  = src.nguoi_mua_co_on_a_xac_nhan,
	    ty_le_chuyen_oi_on_a_at                                     = src.ty_le_chuyen_oi_on_a_at,
	    ty_le_chuyen_oi_on_a_xac_nhan                               = src.ty_le_chuyen_oi_on_a_xac_nhan,
	    doanh_thu_tren_moi_on_on_a_at_vnd                           = src.doanh_thu_tren_moi_on_on_a_at_vnd,
	    doanh_thu_tren_moi_on_on_a_xac_nhan_vnd                     = src.doanh_thu_tren_moi_on_on_a_xac_nhan_vnd,
	    luot_hien_thi_san_pham_duy_nhat                             = src.luot_hien_thi_san_pham_duy_nhat,
	    luot_nhap_san_pham_duy_nhat                                 = src.luot_nhap_san_pham_duy_nhat,
	    luot_truy_cap_san_pham                                      = src.luot_truy_cap_san_pham,
	    luot_xem_trang_san_pham                                     = src.luot_xem_trang_san_pham,
	    so_luong_khach_thoat_trang_san_pham                         = src.so_luong_khach_thoat_trang_san_pham,
	    ty_le_thoat_trang_san_pham                                  = src.ty_le_thoat_trang_san_pham,
	    luot_click_tu_trang_tim_kiem                                = src.luot_click_tu_trang_tim_kiem,
	    luot_thich                                                  = src.luot_thich,
	    luot_truy_cap_san_pham_them_vao_gio_hang                    = src.luot_truy_cap_san_pham_them_vao_gio_hang,
	    san_pham_them_vao_gio_hang                                  = src.san_pham_them_vao_gio_hang,
	    ty_le_chuyen_oi_theo_luot_them_vao_gio_hang                 = src.ty_le_chuyen_oi_theo_luot_them_vao_gio_hang,
	    ty_le_mua_lai_on_a_at                                       = src.ty_le_mua_lai_on_a_at,
	    ty_le_at_hang_lap_lai_on_hang_a_uoc_xac_nhan                = src.ty_le_at_hang_lap_lai_on_hang_a_uoc_xac_nhan,
	    so_ngay_trung_binh_ma_nguoi_mua_quay_lai_at_hang_on_a_at    = src.so_ngay_trung_binh_ma_nguoi_mua_quay_lai_at_hang_on_a_at,
	    so_ngay_trung_binh_e_lap_lai_on_hang_on_hang_a_uoc_xac_nhan = src.so_ngay_trung_binh_e_lap_lai_on_hang_on_hang_a_uoc_xac_nhan
	WHEN NOT MATCHED
	THEN INSERT (
	    thoi_gian, ma_san_pham, san_pham,
	    tinh_trang_san_pham_hien_tai, ma_phan_loai_hang, ten_phan_loai,
	    trang_thai_phan_loai_san_pham_hien_tai, sku_phan_loai, sku_san_pham,
	    doanh_so_on_a_at_vnd, doanh_so_on_a_xac_nhan_vnd,
	    luot_xem_san_pham, luot_nhap_vao_san_pham, ctr,
	    ty_le_chuyen_oi_on_on_a_at, ty_le_chuyen_oi_on_on_a_xac_nhan,
	    on_hang_a_at, on_a_xac_nhan, san_pham_on_a_at, san_pham_on_a_xac_nhan,
	    nguoi_mua_a_at_hang, nguoi_mua_co_on_a_xac_nhan,
	    ty_le_chuyen_oi_on_a_at, ty_le_chuyen_oi_on_a_xac_nhan,
	    doanh_thu_tren_moi_on_on_a_at_vnd, doanh_thu_tren_moi_on_on_a_xac_nhan_vnd,
	    luot_hien_thi_san_pham_duy_nhat, luot_nhap_san_pham_duy_nhat,
	    luot_truy_cap_san_pham, luot_xem_trang_san_pham,
	    so_luong_khach_thoat_trang_san_pham, ty_le_thoat_trang_san_pham,
	    luot_click_tu_trang_tim_kiem, luot_thich,
	    luot_truy_cap_san_pham_them_vao_gio_hang, san_pham_them_vao_gio_hang,
	    ty_le_chuyen_oi_theo_luot_them_vao_gio_hang,
	    ty_le_mua_lai_on_a_at, ty_le_at_hang_lap_lai_on_hang_a_uoc_xac_nhan,
	    so_ngay_trung_binh_ma_nguoi_mua_quay_lai_at_hang_on_a_at,
	    so_ngay_trung_binh_e_lap_lai_on_hang_on_hang_a_uoc_xac_nhan
	)
	VALUES (
	    src.thoi_gian, src.ma_san_pham, src.san_pham,
	    src.tinh_trang_san_pham_hien_tai, src.ma_phan_loai_hang, src.ten_phan_loai,
	    src.trang_thai_phan_loai_san_pham_hien_tai, src.sku_phan_loai, src.sku_san_pham,
	    src.doanh_so_on_a_at_vnd, src.doanh_so_on_a_xac_nhan_vnd,
	    src.luot_xem_san_pham, src.luot_nhap_vao_san_pham, src.ctr,
	    src.ty_le_chuyen_oi_on_on_a_at, src.ty_le_chuyen_oi_on_on_a_xac_nhan,
	    src.on_hang_a_at, src.on_a_xac_nhan, src.san_pham_on_a_at, src.san_pham_on_a_xac_nhan,
	    src.nguoi_mua_a_at_hang, src.nguoi_mua_co_on_a_xac_nhan,
	    src.ty_le_chuyen_oi_on_a_at, src.ty_le_chuyen_oi_on_a_xac_nhan,
	    src.doanh_thu_tren_moi_on_on_a_at_vnd, src.doanh_thu_tren_moi_on_on_a_xac_nhan_vnd,
	    src.luot_hien_thi_san_pham_duy_nhat, src.luot_nhap_san_pham_duy_nhat,
	    src.luot_truy_cap_san_pham, src.luot_xem_trang_san_pham,
	    src.so_luong_khach_thoat_trang_san_pham, src.ty_le_thoat_trang_san_pham,
	    src.luot_click_tu_trang_tim_kiem, src.luot_thich,
	    src.luot_truy_cap_san_pham_them_vao_gio_hang, src.san_pham_them_vao_gio_hang,
	    src.ty_le_chuyen_oi_theo_luot_them_vao_gio_hang,
	    src.ty_le_mua_lai_on_a_at, src.ty_le_at_hang_lap_lai_on_hang_a_uoc_xac_nhan,
	    src.so_ngay_trung_binh_ma_nguoi_mua_quay_lai_at_hang_on_a_at,
	    src.so_ngay_trung_binh_e_lap_lai_on_hang_on_hang_a_uoc_xac_nhan
	);
END;
$procedure$
;
/*
truncate table root_data.order_all

call stg.prc_update_status_fact_txn_orders();
call stg.prc_insert_dim_tables();
call stg.prc_insert_fact_tables();
*/