CREATE OR REPLACE PROCEDURE stg.prc_insert_fact_tables()
 LANGUAGE plpgsql
AS $procedure$
begin
	/*
	 * STEP 1: Đổ dữ liệu cho bảng fact_order_fee
	 */
	truncate table stg.fact_order_fee;
	insert into stg.fact_order_fee 
	(order_id,fee_type_key_id,amount)
	-- fixed fee
	select
		o.ma_don_hang as order_id,
		dft.fee_type_key_id,
		o.phi_co_dinh as amount
	from root_data.orders o
	join stg.dim_fee_type dft
		on dft.fee_type_name = 'fixed_fee'
	union all
	-- payment fee
	select
		o.ma_don_hang,
		dft.fee_type_key_id,
		o.phi_thanh_toan
	from root_data.orders o
	join stg.dim_fee_type dft
		on dft.fee_type_name = 'payment_fee'
	union all
	-- service fee
	select
		o.ma_don_hang,
		dft.fee_type_key_id,
		o.phi_dich_vu
	from root_data.orders o
	join stg.dim_fee_type dft
		on dft.fee_type_name = 'service_fee'
	union all
	-- piship fee
	select
		o.ma_don_hang,
		dft.fee_type_key_id,
		o.gia_goc * 0.00985 as piship_fee
	from root_data.orders o
	join stg.dim_fee_type dft
		on dft.fee_type_name = 'piship_fee'
	union all
	-- discount fee
	select
		o.ma_don_hang,
		dft.fee_type_key_id,
		o.tong_so_tien_duoc_nguoi_ban_tro_gia
	from root_data.orders o
	join stg.dim_fee_type dft
		on dft.fee_type_name = 'discount_fee'
	union all
	-- vat fee
	select
		o.ma_don_hang,
		dft.fee_type_key_id,
		o.gia_goc * 0.01 as vat_fee
	from root_data.orders o
	join stg.dim_fee_type dft
		on dft.fee_type_name = 'vat_fee'
	union all
	-- income tax fee
	select
		o.ma_don_hang,
		dft.fee_type_key_id,
		o.gia_goc * 0.005 as income_tax_fee
	from root_data.orders o
	join stg.dim_fee_type dft
		on dft.fee_type_name = 'income_tax_fee'
	union all	
	-- ads fee
	select
		o.ma_don_hang,
		dft.fee_type_key_id,
		null as ads_fee
	from root_data.orders o
	join stg.dim_fee_type dft
		on dft.fee_type_name = 'ads_fee';
	
	/*
	 * STEP 3: Đổ dữ liệu cho bảng fact_txn_orders
	 */	
	truncate table stg.fact_txn_orders;
	INSERT INTO stg.fact_txn_orders
	(transaction_order_id, order_id, key_customer_id, order_date_key, order_date, order_status_id, order_cancel_reason_id, refund_status, total_price, payment_method_id, order_complete_date_key, order_complete_dt)
	select
		row_number() over(order by min(o.ngay_dat_hang), o.ma_don_hang) as transaction_order_id,
		o.ma_don_hang as order_id, 
		c.key_customer_id,
		max(dt.date_key) as order_date_key,
		min(o.ngay_dat_hang) as order_date,
		max(os.order_status_id) as order_status_id,
		max(ocr.order_cancel_reason_id) as order_cancel_reason_id,
		max(o.trang_thai_tra_hang_hoan_tien) as refund_status,
		sum(o.gia_goc) as total_price,
		max(pm.payment_method_id) as payment_method_id,
		min(dt2.date_key) as order_complete_date_key,
		min(o.thoi_gian_hoan_thanh_don_hang) as order_complete_dt
	from root_data.orders o
	left join stg.dim_date dt
		on dt.full_date = o.ngay_dat_hang::date
	left join stg.dim_date dt2
		on dt2.full_date = o.thoi_gian_giao_hang::date
	left join stg.dim_customer c
		on c.customer_id = o.nguoi_mua
	left join stg.dim_order_status os
		on os.order_status =
		(
			case
			when o.trang_thai_tra_hang_hoan_tien = 'Đã Chấp Thuận Yêu Cầu'
				then 'Hoàn trả'
			when o.trang_thai_don_hang like
				'Người mua xác nhận đã nhận được hàng%'
				then 'Đã nhận hàng chờ refund'
			when o.trang_thai_don_hang = 'Đã hủy'
				then 'Đã hủy'
			when o.trang_thai_don_hang = 'Đang giao'
				then 'Đang giao'
			when o.trang_thai_don_hang = 'Đã giao'
				then 'Đã giao'
			when o.trang_thai_don_hang = 'Đã nhận được hàng'
				then 'Đã nhận được hàng'
			when o.trang_thai_don_hang = 'Hoàn thành'
				then 'Hoàn thành'
			when o.trang_thai_don_hang = 'Chờ giao hàng'
				then 'Chờ giao hàng'
		end
		)
	left join stg.dim_order_cancel_reason ocr
		on ocr.order_cancel_reason = o.ly_do_huy
	left join stg.dim_payment_method pm
		on pm.payment_method = o.phuong_thuc_thanh_toan
	group by o.ma_don_hang,c.key_customer_id ;


	/*
	 * STEP 3: Đổ dữ liệu cho bảng fact_order_detail
	 */	
	truncate table stg.fact_order_detail;
	INSERT INTO stg.fact_order_detail
	(order_id,transaction_order_id ,key_product_id, key_variants_id, total_price, quantity, unit_cost)
	select
		o.ma_don_hang as order_id, 
		fto.transaction_order_id,
		dp.key_product_id, 
		dv.key_variants_id, 
		o.gia_goc as total_price,
		o.so_luong as quantity, 
		dvch.unit_cost
	from root_data.orders o
	--mã đơn hàng
	left join stg.fact_txn_orders fto on fto.order_id = o.ma_don_hang
	--mã sản phẩm
	left join stg.dim_products dp on dp.product_code = lower(o.sku_san_pham)
	--mã phân loại
	left join stg.dim_variants dv on dv.variants_code = lower(o.sku_phan_loai_hang)
	--thời gian cost lúc đó
	left join stg.face_variant_cost_history dvch
	on dvch.key_variants_id = dv.key_variants_id
	and o.ngay_dat_hang >= dvch.valid_from
	and
	(
		o.ngay_dat_hang <= dvch.valid_to
		or dvch.valid_to is null
	);


	/*
	 * STEP 4: Đổ dữ liệu cho bảng fact_product_performance
	 */	
	truncate table stg.fact_product_performance;
	INSERT INTO stg.fact_product_performance
	(date_time, key_product_id, views_count, clicks, exit_count, add_to_cart, orders, ordered_items, ordered_revenue)
	select 
		date_time,
		key_product_id,
		views_count,
		clicks,
		exit_count,
		add_to_cart,
		ordered_orders as orders,
		ordered_items,
		ordered_revenue
	from
	(
		select
			pp.thoi_gian as date_time,
			dp.key_product_id,
			case
				when pp.ten_phan_loai ='-' then 'parent'
				else 'child'
			end as row_type, 
			pp.luot_xem_san_pham::int as views_count,
			pp.luot_nhap_vao_san_pham::int as clicks, 
			pp.so_luong_khach_thoat_trang_san_pham::int as exit_count,
			pp.san_pham_them_vao_gio_hang::int as add_to_cart,
			replace(pp.doanh_so_on_a_xac_nhan_vnd,'.','')::numeric as ordered_revenue, 
			pp.on_a_xac_nhan::int as ordered_orders, 
			pp.san_pham_on_a_xac_nhan::int as ordered_items
		from root_data.product_performance pp
		left join stg.dim_variants dv 
			on dv.variants_code = lower(pp.sku_phan_loai)
		join stg.dim_products dp
			on dp.product_name = lower(pp.san_pham)
	)x
	where row_type = 'parent';


	/*
	 * STEP 5: Đổ dữ liệu cho bảng fact_campaign_performance
	 */	
	truncate table stg.fact_campaign_performance;
	INSERT INTO stg.fact_campaign_performance
	(campaign_key_id, key_product_id, date_time, views_count, clicks, conversion_count, total_fee)
	select
		cp.campaign_key_id::int, 
		dp.key_product_id, 
		cp.thoi_gian as date_time, 
		cp.so_luot_xem::int as views_count, 
		cp.so_luot_click::int as clicks, 
		cp.luot_chuyen_doi::int as conversion_count, 
		(cp.luot_chuyen_doi::int * cp.chi_phi_cho_moi_luot_chuyen_doi::numeric) as total_fee
	from root_data.campaign_performance_csv cp
	left join stg.dim_products dp on dp.product_name = lower(cp.ten_san_pham);
	
	/*
	 * STEP 6: Đổ dữ liệu cho bảng fact_daily_profit_and_loss
	 */	
	truncate table stg.fact_daily_profit_and_loss;
	INSERT INTO stg.fact_daily_profit_and_loss
	(date_key, pl_id, amount)
	with raw as (
	    --paid_revenue
	    select
	        o.order_date_key as date_key, 
	        dpl.pl_id, 
	        sum(COALESCE(o.total_price, 0)) as amount
	    from stg.fact_txn_orders o
	    left join stg.dim_profit_and_loss dpl on dpl.pl_code = 'paid_revenue'
	    where o.order_status_id in (5,6)
	    group by 1,2
	
	    union all
	    --pending_revenue
	    select
	        o.order_date_key as date_key, 
	        dpl.pl_id, 
	        sum(COALESCE(o.total_price, 0)) as amount
	    from stg.fact_txn_orders o
	    left join stg.dim_profit_and_loss dpl on dpl.pl_code = 'pending_revenue'
	    where o.order_status_id in (2,3)
	    group by 1,2
	
	    union all
	    --cost
	    select
	        o.order_date_key as date_key,
	        dpl.pl_id,
	        sum(coalesce(fod.unit_cost,0) * coalesce(fod.quantity,0)) as amount
	    from stg.fact_txn_orders o
	    join stg.fact_order_detail fod on fod.transaction_order_id = o.transaction_order_id
	    join stg.dim_profit_and_loss dpl on dpl.pl_code = 'unit_cost'
	    where o.order_status_id in (2,3,5,6)
	    group by 1,2
	
	    union all
	    --fee
	    select 
	        o.order_date_key as date_key,
	        dpl.pl_id, 
	        sum(coalesce(fof.amount,0)) as amount
	    from stg.fact_order_fee fof 
	    left join stg.fact_txn_orders o on o.order_id = fof.order_id
	    left join stg.dim_fee_type dft on dft.fee_type_key_id = fof.fee_type_key_id
	    left join stg.dim_profit_and_loss dpl on dpl.pl_code = dft.fee_type_name
	    where o.order_status_id in (2,3,5,6)
	    group by 1,2
	),
	-- lấy date_key từ chính raw thay vì từ toàn bộ fact_txn_orders
	full_spine as 
	(
	    select distinct d.date_key, p.pl_id
	    from (select distinct date_key from raw) d
	    cross join stg.dim_profit_and_loss p
	)
	
	select
	    fs.date_key,
	    fs.pl_id,
	    coalesce(r.amount, 0) as amount
	from full_spine fs
	left join 
	(
	    select date_key, pl_id, sum(amount) as amount
	    from raw
	    group by 1,2
	) r on r.date_key = fs.date_key and r.pl_id = fs.pl_id
	order by 1, 2;

	/*
	 * STEP 7: Đổ dữ liệu cho bảng fact_monthly_profit_and_loss
	 */	
	truncate table stg.fact_monthly_profit_and_loss;
	INSERT INTO stg.fact_monthly_profit_and_loss
	(date_key, pl_id, amount)
	select date_key,pl_id,amount
	from
	(
		select
			substring(min(dd.date_key),1,6) as date_key,
			dd.year_number,
			dd.month_number,
			dpal.pl_id,
			sum(fdpal.amount) as amount
		from stg.fact_daily_profit_and_loss fdpal 
		join stg.dim_date dd 
			on dd.date_key = fdpal.date_key
		join stg.dim_profit_and_loss dpal 
			on dpal.pl_id = fdpal.pl_id
		group by 2,3,4
	)x;

	/*
	 * STEP 8: Đổ dữ liệu cho bảng fact_annually_profit_and_loss
	 */	
	truncate table stg.fact_annually_profit_and_loss;
	INSERT INTO stg.fact_annually_profit_and_loss
	(date_key, pl_id, amount)
	select date_key,pl_id,amount
	from
	(
		select
			substring(min(dd.date_key),1,4) as date_key,
			dd.year_number,
			dpal.pl_id,
			sum(fdpal.amount) as amount
		from stg.fact_daily_profit_and_loss fdpal 
		join stg.dim_date dd 
			on dd.date_key = fdpal.date_key
		join stg.dim_profit_and_loss dpal 
			on dpal.pl_id = fdpal.pl_id
		group by 2,3
	)x;

	/*
	 * STEP 9: Đổ dữ liệu cho bảng fact_monthly_products_performance
	 */	
	truncate table stg.fact_monthly_products_performance;
	INSERT INTO stg.fact_monthly_products_performance
	(month_key, brand_id, category_id, metric_id, amount)
	WITH order_brand_category AS 
	(
	    select distinct
	        substring(dd.date_key,1,6) as month_key,
	        fto.transaction_order_id,
	        db.key_brand_id,
	        dc.key_category_id
	    from stg.fact_txn_orders fto
	    join stg.fact_order_detail fod
	        on fod.transaction_order_id = fto.transaction_order_id
	    join stg.dim_products dp
	        on dp.key_product_id = fod.key_product_id
	    join stg.dim_brands db
	        on db.key_brand_id = dp.key_brand_id
	    join stg.dim_date dd
	        on dd.full_date = fto.order_date::date
	    join stg.dim_category dc 
	    	on dc.key_category_id = dp.key_category_id
	    where fto.order_status_id in (2,3,5,6)
	),
	product_perf AS (
	    select
	        substring(dd.date_key,1,6) as month_key,
	        db.key_brand_id,
			dc.key_category_id,
	        coalesce(sum(fpp.views_count),0) as views_count,
	        coalesce(sum(fpp.clicks),0) as clicks,
	        coalesce(sum(fpp.exit_count),0) as exit_count,
	        coalesce(sum(fpp.add_to_cart),0) as add_to_cart,
	        coalesce(sum(fpp.orders),0) as orders
	    from stg.fact_product_performance fpp
	    join stg.dim_products dp
	        on dp.key_product_id = fpp.key_product_id
	    join stg.dim_brands db
	        on db.key_brand_id = dp.key_brand_id
		join stg.dim_category dc
			on dc.key_category_id = dp.key_category_id
	    join stg.dim_date dd
	        on dd.full_date = fpp.date_time::date
	    group by 1,2,3
	),
	
	product_perform AS (
	    select
	        coalesce(pp.month_key) as month_key,
	        coalesce(pp.key_brand_id) as key_brand_id,
			coalesce(pp.key_category_id) as key_category_id,
	        coalesce(pp.views_count,0) as views_count,
	        coalesce(pp.clicks,0) as clicks,
	        coalesce(pp.exit_count,0) as exit_count,
	        coalesce(pp.add_to_cart,0) as add_to_cart,
	        coalesce(pp.orders,0) as orders
	    from product_perf pp
	
	)
	
	select
	    month_key,
	    key_brand_id,
	    key_category_id,
	    1 as metric_id,
	    views_count as amount
	from product_perform
	union all
	select
	    month_key,
	    key_brand_id,
	    key_category_id,
	    2,
	    clicks
	from product_perform
	union all
	select
	    month_key,
	    key_brand_id,
	    key_category_id,
	    3,
	    exit_count
	from product_perform
	union all
	select
	    month_key,
	    key_brand_id,
	    key_category_id,
	    4,
	    add_to_cart
	from product_perform
	union all
	select
	    month_key,
	    key_brand_id,
	    key_category_id,
	    5,
	    orders
	from product_perform;

	/*
	 * STEP 10: Đổ dữ liệu cho bảng fact_customer_monthly_metrics
	 */	
	truncate table stg.fact_customer_monthly_metrics;
	INSERT INTO stg.fact_customer_monthly_metrics
	(month_key, customer_id, city, district, metric_id, value)
	--lấy ra thông tin nền tảng của khách hàng
	with customer_monthly_base as (
	    select
	        substring(dd.date_key,1,6) as month_key,
	        customer.customer_id,
	        dc.city_name as city,
	        dd2.district_name as district,
	        -- tổng đơn hàng
	        count(distinct fto.order_id) as total_orders,
	        -- tổng đơn hoàn thành
	        count(distinct case
	            when fto.order_status_id = 6
	            then fto.order_id
	        end) as completed_orders,
	        -- tổng đơn hủy
	        count(distinct case
	            when fto.order_status_id = 0
	            then fto.order_id
	        end) as canceled_orders,
	        -- tổng doanh thu
	        sum(fto.total_price) as total_revenue
	    from stg.fact_txn_orders fto
	    join stg.dim_date dd
	        on dd.date_key = fto.order_date_key
	    left join stg.dim_customer customer
	        on customer.key_customer_id = fto.key_customer_id
	    left join stg.dim_city dc
	        on dc.key_city_id = customer.city_key
	    left join stg.dim_district dd2
	        on dd2.key_district_id = customer.district_key
	    group by 1,2,3,4
	),
	
	-- lấy ra tháng mua đầu tiên của khách
	first_purchase as (
	    select
	        customer.customer_id,
	        min(substring(dd.date_key,1,6)) as first_month_key
	    from stg.fact_txn_orders fto
	    join stg.dim_date dd
	        on dd.date_key = fto.order_date_key
	    join stg.dim_customer customer
	        on customer.key_customer_id = fto.key_customer_id
	    group by 1
	),
	
	-- lifetime metrics
	customer_lifetime as (
	    select
	        customer.customer_id,
	        count(distinct fto.order_id) as lifetime_orders,
	        sum(fto.total_price) as lifetime_revenue
	    from stg.fact_txn_orders fto
	    join stg.dim_customer customer
	        on customer.key_customer_id = fto.key_customer_id
	    group by 1
	),
	
	-- previous order
	customer_order_sequence as (
	    select
	        substring(dd.date_key,1,6) as month_key,
	        customer.customer_id,
	        to_date(fto.order_date_key,'YYYYMMDD') as order_date,
	        lag(
	            to_date(fto.order_date_key,'YYYYMMDD')
	        ) over(
	            partition by customer.customer_id
	            order by to_date(fto.order_date_key,'YYYYMMDD')
	        ) as prev_order_date
	    from stg.fact_txn_orders fto
	    join stg.dim_date dd
	        on dd.date_key = fto.order_date_key
	    join stg.dim_customer customer
	        on customer.key_customer_id = fto.key_customer_id
	),
	-- khoảng cách giữa các lần mua
	customer_days_since_last_order as (
	    select
	        month_key,
	        customer_id,
	        max(order_date - prev_order_date)
	         as days_since_last_order
	    from customer_order_sequence
	    where prev_order_date is not null
	    group by 1,2
	),
	-- định nghĩa metrics
	final_customer_metrics as (
	    select
	        cmb.month_key,
	        cmb.customer_id,
	        cmb.city,
	        cmb.district,
	        cmb.total_orders,
	        cmb.completed_orders,
	        cmb.canceled_orders,
	        cmb.total_revenue,
	        -- AOV
	        cmb.total_revenue
	            / nullif(cmb.total_orders,0)
	            as avg_order_value,
	        -- purchase frequency
	        cmb.total_orders * 1.0
	            as purchase_frequency,
	        -- new customer
	        case
	            when cmb.month_key = fp.first_month_key
	            then 1
	            else 0
	        end as is_new_customer,
	        -- returning customer
	        case
	            when cmb.total_orders > 1
	            then 1
	            else 0
	        end as is_returning_customer,
	        -- active customer
	        case
	            when cmb.total_orders > 0
	            then 1
	            else 0
	        end as is_active_customer,
	        cl.lifetime_orders,
	        cl.lifetime_revenue,
	        dsl.days_since_last_order
	    from customer_monthly_base cmb
	
	    left join first_purchase fp
	        on fp.customer_id = cmb.customer_id
	
	    left join customer_lifetime cl
	        on cl.customer_id = cmb.customer_id
	      
		left join customer_days_since_last_order dsl
	    	on dsl.customer_id = cmb.customer_id
	    	and dsl.month_key = cmb.month_key
	)
	
	-- unpivot metrics
	select
	    month_key,
	    customer_id,
	    city,
	    district,
	    metric_id,
	    value
	
	from (
	    -- total orders
	    select month_key, customer_id, city, district,
	        4 as metric_id,
	        total_orders as value
	    from final_customer_metrics
	    union all
	    -- completed orders
	    select month_key, customer_id, city, district,
	        5,
	        completed_orders
	    from final_customer_metrics
	    union all
	    -- canceled orders
	    select month_key, customer_id, city, district,
	        6,
	        canceled_orders
	    from final_customer_metrics
	    union all
	    -- revenue
	    select month_key, customer_id, city, district,
	        7,
	        total_revenue
	    from final_customer_metrics
	    union all
	    -- avg order value
	    select month_key, customer_id, city, district,
	        10,
	        avg_order_value
	    from final_customer_metrics
	    union all
	    -- purchase frequency
	    select month_key, customer_id, city, district,
	        11,
	        purchase_frequency
	    from final_customer_metrics
	    union all
	    -- avg days between orders
	    select month_key, customer_id, city, district,
	        12,
	        days_since_last_order
	    from final_customer_metrics
	    union all
	    -- lifetime orders
	    select month_key, customer_id, city, district,
	        13,
	        lifetime_orders
	    from final_customer_metrics
	    union all
	    -- lifetime revenue
	    select month_key, customer_id, city, district,
	        14,
	        lifetime_revenue
	    from final_customer_metrics
	    union all
	    -- is new customer
	    select month_key, customer_id, city, district,
	        15,
	        is_new_customer
	    from final_customer_metrics
	    union all
	    -- is returning customer
	    select month_key, customer_id, city, district,
	        16,
	        is_returning_customer
	    from final_customer_metrics
	    union all
	    -- is active customer
	    select month_key, customer_id, city, district,
	        17,
	        is_active_customer
	    from final_customer_metrics
	);

	/*
	 * STEP 10: Đổ dữ liệu cho bảng fact_monthly_risk_management
	 */	
	truncate table stg.fact_monthly_risk_management;
	INSERT INTO stg.fact_monthly_risk_management
	(month_key, city, district, key_product_id, key_brand_id, payment_method_id, metrics_id, metrics_value)
	with
	-- =========================================
	-- BASE DIMENSIONS
	-- tạo tất cả combinations có thể
	-- =========================================
	all_dimensions as (
	    select distinct
	        substring(dt.date_key,1,6) as month_key,
	        city.city_name,
	        district.district_name,
	        fod.key_product_id,
	        dp.key_brand_id,
	        fto.payment_method_id
	    from stg.fact_txn_orders fto
	    join stg.dim_date dt
	        on dt.full_date = fto.order_date::date
	    join stg.fact_order_detail fod
	        on fod.order_id = fto.order_id
	    join stg.dim_customer dc
	        on dc.key_customer_id = fto.key_customer_id
	    join stg.dim_products dp
	        on dp.key_product_id = fod.key_product_id
	    join stg.dim_city city
	        on city.key_city_id = dc.city_key
	    join stg.dim_district district
	        on district.key_district_id = dc.district_key
	),
	
	all_metrics as (
	    select metrics_id from (values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13)) t(metrics_id)
	),
	
	-- spine: tất cả combinations x 13 metrics
	spine as (
	    select d.*, m.metrics_id
	    from all_dimensions d
	    cross join all_metrics m
	),
	
	-- =========================================
	-- TOTAL ORDERS - metrics_id = 1
	-- =========================================
	m1 as (
	    select
	        substring(dt.date_key,1,6) as month_key,
	        city.city_name,
	        district.district_name,
	        fod.key_product_id,
	        dp.key_brand_id,
	        fto.payment_method_id,
	        1 as metrics_id,
	        count(distinct fto.order_id) as metrics_value
	    from stg.fact_txn_orders fto
	    join stg.dim_date dt on dt.full_date = fto.order_date::date
	    join stg.fact_order_detail fod on fod.order_id = fto.order_id
	    join stg.dim_customer dc on dc.key_customer_id = fto.key_customer_id
	    join stg.dim_products dp on dp.key_product_id = fod.key_product_id
	    join stg.dim_city city on city.key_city_id = dc.city_key
	    join stg.dim_district district on district.key_district_id = dc.district_key
	    group by 1,2,3,4,5,6
	),
	
	-- =========================================
	-- COMPLETED ORDERS - metrics_id = 2
	-- =========================================
	m2 as (
	    select
	        substring(dt.date_key,1,6) as month_key,
	        city.city_name,
	        district.district_name,
	        fod.key_product_id,
	        dp.key_brand_id,
	        fto.payment_method_id,
	        2 as metrics_id,
	        count(distinct fto.order_id) as metrics_value
	    from stg.fact_txn_orders fto
	    join stg.dim_date dt on dt.full_date = fto.order_date::date
	    join stg.fact_order_detail fod on fod.order_id = fto.order_id
	    join stg.dim_customer dc on dc.key_customer_id = fto.key_customer_id
	    join stg.dim_products dp on dp.key_product_id = fod.key_product_id
	    join stg.dim_city city on city.key_city_id = dc.city_key
	    join stg.dim_district district on district.key_district_id = dc.district_key
	    where fto.order_status_id = 6
	    group by 1,2,3,4,5,6
	),
	
	-- =========================================
	-- CANCELED ORDERS - metrics_id = 3
	-- =========================================
	m3 as (
	    select
	        substring(dt.date_key,1,6) as month_key,
	        city.city_name,
	        district.district_name,
	        fod.key_product_id,
	        dp.key_brand_id,
	        fto.payment_method_id,
	        3 as metrics_id,
	        count(distinct fto.order_id) as metrics_value
	    from stg.fact_txn_orders fto
	    join stg.dim_date dt on dt.full_date = fto.order_date::date
	    join stg.fact_order_detail fod on fod.order_id = fto.order_id
	    join stg.dim_customer dc on dc.key_customer_id = fto.key_customer_id
	    join stg.dim_products dp on dp.key_product_id = fod.key_product_id
	    join stg.dim_city city on city.key_city_id = dc.city_key
	    join stg.dim_district district on district.key_district_id = dc.district_key
	    where fto.order_status_id = 0
	    group by 1,2,3,4,5,6
	),
	
	-- =========================================
	-- DELIVERED ORDERS - metrics_id = 4
	-- =========================================
	m4 as (
	    select
	        substring(dt.date_key,1,6) as month_key,
	        city.city_name,
	        district.district_name,
	        fod.key_product_id,
	        dp.key_brand_id,
	        fto.payment_method_id,
	        4 as metrics_id,
	        count(distinct fto.order_id) as metrics_value
	    from stg.fact_txn_orders fto
	    join stg.dim_date dt on dt.full_date = fto.order_date::date
	    join stg.fact_order_detail fod on fod.order_id = fto.order_id
	    join stg.dim_customer dc on dc.key_customer_id = fto.key_customer_id
	    join stg.dim_products dp on dp.key_product_id = fod.key_product_id
	    join stg.dim_city city on city.key_city_id = dc.city_key
	    join stg.dim_district district on district.key_district_id = dc.district_key
	    where fto.order_status_id in (3,5,6,-1)
	    group by 1,2,3,4,5,6
	),
	
	-- =========================================
	-- REFUND REQUESTED ORDERS - metrics_id = 5
	-- =========================================
	m5 as (
	    select
	        substring(dt.date_key,1,6) as month_key,
	        city.city_name,
	        district.district_name,
	        fod.key_product_id,
	        dp.key_brand_id,
	        fto.payment_method_id,
	        5 as metrics_id,
	        count(distinct fto.order_id) as metrics_value
	    from stg.fact_txn_orders fto
	    join stg.dim_date dt on dt.full_date = fto.order_date::date
	    join stg.fact_order_detail fod on fod.order_id = fto.order_id
	    join stg.dim_customer dc on dc.key_customer_id = fto.key_customer_id
	    join stg.dim_products dp on dp.key_product_id = fod.key_product_id
	    join stg.dim_city city on city.key_city_id = dc.city_key
	    join stg.dim_district district on district.key_district_id = dc.district_key
	    where fto.order_status_id = -1
	    group by 1,2,3,4,5,6
	),
	
	-- =========================================
	-- APPROVED REFUND ORDERS - metrics_id = 6
	-- =========================================
	m6 as (
	    select
	        substring(dt.date_key,1,6) as month_key,
	        city.city_name,
	        district.district_name,
	        fod.key_product_id,
	        dp.key_brand_id,
	        fto.payment_method_id,
	        6 as metrics_id,
	        count(distinct fto.order_id) as metrics_value
	    from stg.fact_txn_orders fto
	    join stg.dim_date dt on dt.full_date = fto.order_date::date
	    join stg.fact_order_detail fod on fod.order_id = fto.order_id
	    join stg.dim_customer dc on dc.key_customer_id = fto.key_customer_id
	    join stg.dim_products dp on dp.key_product_id = fod.key_product_id
	    join stg.dim_city city on city.key_city_id = dc.city_key
	    join stg.dim_district district on district.key_district_id = dc.district_key
	    where fto.refund_status = N'Đã Chấp Thuận Yêu Cầu'
	    group by 1,2,3,4,5,6
	),
	
	-- =========================================
	-- DISPUTED REFUND ORDERS - metrics_id = 7
	-- =========================================
	m7 as (
	    select
	        substring(dt.date_key,1,6) as month_key,
	        city.city_name,
	        district.district_name,
	        fod.key_product_id,
	        dp.key_brand_id,
	        fto.payment_method_id,
	        7 as metrics_id,
	        count(distinct fto.order_id) as metrics_value
	    from stg.fact_txn_orders fto
	    join stg.dim_date dt on dt.full_date = fto.order_date::date
	    join stg.fact_order_detail fod on fod.order_id = fto.order_id
	    join stg.dim_customer dc on dc.key_customer_id = fto.key_customer_id
	    join stg.dim_products dp on dp.key_product_id = fod.key_product_id
	    join stg.dim_city city on city.key_city_id = dc.city_key
	    join stg.dim_district district on district.key_district_id = dc.district_key
	    where fto.refund_status = N'Đã giải quyết khiếu nại'
	    group by 1,2,3,4,5,6
	),
	
	-- =========================================
	-- RETURNED ORDERS - metrics_id = 8
	-- =========================================
	m8 as (
	    select
	        substring(dt.date_key,1,6) as month_key,
	        city.city_name,
	        district.district_name,
	        fod.key_product_id,
	        dp.key_brand_id,
	        fto.payment_method_id,
	        8 as metrics_id,
	        count(distinct fto.order_id) as metrics_value
	    from stg.fact_txn_orders fto
	    join stg.dim_date dt on dt.full_date = fto.order_date::date
	    join stg.fact_order_detail fod on fod.order_id = fto.order_id
	    join stg.dim_customer dc on dc.key_customer_id = fto.key_customer_id
	    join stg.dim_products dp on dp.key_product_id = fod.key_product_id
	    join stg.dim_city city on city.key_city_id = dc.city_key
	    join stg.dim_district district on district.key_district_id = dc.district_key
	    where fto.order_status_id = -1
	    group by 1,2,3,4,5,6
	),
	
	-- =========================================
	-- TOTAL GMV - metrics_id = 9
	-- =========================================
	m9 as (
	    select
	        substring(dt.date_key,1,6) as month_key,
	        city.city_name,
	        district.district_name,
	        fod.key_product_id,
	        dp.key_brand_id,
	        fto.payment_method_id,
	        9 as metrics_id,
	        sum(fto_dedup.total_price) as metrics_value
	    from (
	        select order_id, total_price,
	               row_number() over (partition by order_id order by order_id) as rn
	        from stg.fact_txn_orders
	    ) fto_dedup
	    join stg.fact_txn_orders fto on fto.order_id = fto_dedup.order_id and fto_dedup.rn = 1
	    join stg.dim_date dt on dt.full_date = fto.order_date::date
	    join stg.fact_order_detail fod on fod.order_id = fto.order_id
	    join stg.dim_customer dc on dc.key_customer_id = fto.key_customer_id
	    join stg.dim_products dp on dp.key_product_id = fod.key_product_id
	    join stg.dim_city city on city.key_city_id = dc.city_key
	    join stg.dim_district district on district.key_district_id = dc.district_key
	    group by 1,2,3,4,5,6
	),
	
	-- =========================================
	-- COMPLETED GMV - metrics_id = 10
	-- =========================================
	m10 as (
	    select
	        substring(dt.date_key,1,6) as month_key,
	        city.city_name,
	        district.district_name,
	        fod.key_product_id,
	        dp.key_brand_id,
	        fto.payment_method_id,
	        10 as metrics_id,
	        sum(fto_dedup.total_price) as metrics_value
	    from (
	        select order_id, total_price,
	               row_number() over (partition by order_id order by order_id) as rn
	        from stg.fact_txn_orders
	        where order_status_id = 6
	    ) fto_dedup
	    join stg.fact_txn_orders fto on fto.order_id = fto_dedup.order_id and fto_dedup.rn = 1
	    join stg.dim_date dt on dt.full_date = fto.order_date::date
	    join stg.fact_order_detail fod on fod.order_id = fto.order_id
	    join stg.dim_customer dc on dc.key_customer_id = fto.key_customer_id
	    join stg.dim_products dp on dp.key_product_id = fod.key_product_id
	    join stg.dim_city city on city.key_city_id = dc.city_key
	    join stg.dim_district district on district.key_district_id = dc.district_key
	    group by 1,2,3,4,5,6
	),
	
	-- =========================================
	-- CANCELED GMV - metrics_id = 11
	-- =========================================
	m11 as (
	    select
	        substring(dt.date_key,1,6) as month_key,
	        city.city_name,
	        district.district_name,
	        fod.key_product_id,
	        dp.key_brand_id,
	        fto.payment_method_id,
	        11 as metrics_id,
	        sum(fto_dedup.total_price) as metrics_value
	    from (
	        select order_id, total_price,
	               row_number() over (partition by order_id order by order_id) as rn
	        from stg.fact_txn_orders
	        where order_status_id = 0
	    ) fto_dedup
	    join stg.fact_txn_orders fto on fto.order_id = fto_dedup.order_id and fto_dedup.rn = 1
	    join stg.dim_date dt on dt.full_date = fto.order_date::date
	    join stg.fact_order_detail fod on fod.order_id = fto.order_id
	    join stg.dim_customer dc on dc.key_customer_id = fto.key_customer_id
	    join stg.dim_products dp on dp.key_product_id = fod.key_product_id
	    join stg.dim_city city on city.key_city_id = dc.city_key
	    join stg.dim_district district on district.key_district_id = dc.district_key
	    group by 1,2,3,4,5,6
	),
	
	-- =========================================
	-- REFUND REQUESTED GMV - metrics_id = 12
	-- =========================================
	m12 as (
	    select
	        substring(dt.date_key,1,6) as month_key,
	        city.city_name,
	        district.district_name,
	        fod.key_product_id,
	        dp.key_brand_id,
	        fto.payment_method_id,
	        12 as metrics_id,
	        sum(fto_dedup.total_price) as metrics_value
	    from (
	        select order_id, total_price,
	               row_number() over (partition by order_id order by order_id) as rn
	        from stg.fact_txn_orders
	        where order_status_id = -1
	    ) fto_dedup
	    join stg.fact_txn_orders fto on fto.order_id = fto_dedup.order_id and fto_dedup.rn = 1
	    join stg.dim_date dt on dt.full_date = fto.order_date::date
	    join stg.fact_order_detail fod on fod.order_id = fto.order_id
	    join stg.dim_customer dc on dc.key_customer_id = fto.key_customer_id
	    join stg.dim_products dp on dp.key_product_id = fod.key_product_id
	    join stg.dim_city city on city.key_city_id = dc.city_key
	    join stg.dim_district district on district.key_district_id = dc.district_key
	    group by 1,2,3,4,5,6
	),
	
	-- =========================================
	-- APPROVED REFUND GMV - metrics_id = 13
	-- =========================================
	m13 as (
	    select
	        substring(dt.date_key,1,6) as month_key,
	        city.city_name,
	        district.district_name,
	        fod.key_product_id,
	        dp.key_brand_id,
	        fto.payment_method_id,
	        13 as metrics_id,
	        sum(fto_dedup.total_price) as metrics_value
	    from (
	        select order_id, total_price,
	               row_number() over (partition by order_id order by order_id) as rn
	        from stg.fact_txn_orders
	        where refund_status = N'Đã Chấp Thuận Yêu Cầu'
	    ) fto_dedup
	    join stg.fact_txn_orders fto on fto.order_id = fto_dedup.order_id and fto_dedup.rn = 1
	    join stg.dim_date dt on dt.full_date = fto.order_date::date
	    join stg.fact_order_detail fod on fod.order_id = fto.order_id
	    join stg.dim_customer dc on dc.key_customer_id = fto.key_customer_id
	    join stg.dim_products dp on dp.key_product_id = fod.key_product_id
	    join stg.dim_city city on city.key_city_id = dc.city_key
	    join stg.dim_district district on district.key_district_id = dc.district_key
	    group by 1,2,3,4,5,6
	),
	
	-- union tất cả metrics lại
	all_metrics_data as (
	    select * from m1
	    union all select * from m2
	    union all select * from m3
	    union all select * from m4
	    union all select * from m5
	    union all select * from m6
	    union all select * from m7
	    union all select * from m8
	    union all select * from m9
	    union all select * from m10
	    union all select * from m11
	    union all select * from m12
	    union all select * from m13
	)
	
	-- =========================================
	-- FINAL: LEFT JOIN spine với data thực tế
	-- đảm bảo đủ 13 metrics cho mọi combination
	-- =========================================
	select
	    s.month_key,
	    s.city_name,
	    s.district_name,
	    s.key_product_id,
	    s.key_brand_id,
	    s.payment_method_id,
	    s.metrics_id,
	    coalesce(m.metrics_value, 0) as metrics_value
	from spine s
	left join all_metrics_data m
	    on  m.month_key        = s.month_key
	    and m.city_name        = s.city_name
	    and m.district_name    = s.district_name
	    and m.key_product_id   = s.key_product_id
	    and m.key_brand_id     = s.key_brand_id
	    and m.payment_method_id = s.payment_method_id
	    and m.metrics_id       = s.metrics_id;
end;
$procedure$ 
;



--call stg.prc_insert_fact_tables();



