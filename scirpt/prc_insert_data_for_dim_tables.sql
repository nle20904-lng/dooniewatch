	CREATE OR REPLACE PROCEDURE stg.prc_insert_dim_tables()
	 LANGUAGE plpgsql
	AS $procedure$
	begin
		/*
		 * Việc đổ dữ liệu thông tin các bảng dim lần đầu, chỉ chạy 1 lần và không chạy lại.
		 */
		/*
		 * STEP 1: đổ dữ liệu bảng brand
		 */
		truncate table stg.dim_brands;
		INSERT INTO stg.dim_brands
		(key_brand_id, brand_name, brand_desc, brand_status, register_dt, rec_created_dt, rec_updated_dt)
		select rank() over( order by thuonghieu) as key_brand_id, 
		thuonghieu as brand_name, 
		thuonghieu as brand_desc, 
		1 as brand_status, 
		now() as register_dt, 
		now() as rec_created_dt, 
		now() as rec_updated_dt
		from 
		(
			select thuonghieu
			from root_data.sanpham s 
			where thuonghieu <> 'No brand'
			group by thuonghieu 
		) x 
		union 
		select -1 as key_brand_id, 
		'No brand' as brand_name, 
		'No brand' as brand_desc, 
		1 as brand_status, 
		now() as register_dt, 
		now() as rec_created_dt, 
		now() as rec_updated_dt ;
	
		/*
		 * STEP 2: đổ dữ liệu bảng gender
		 */
	
		truncate table stg.dim_gender;
		INSERT INTO stg.dim_gender
		(key_gender_id, gender_name, gender_desc, gender_status, register_dt, rec_created_dt, rec_updated_dt)
		select rank() over( order by gioitinh) as key_gender_id, 
		gioitinh as gender_name, 
		gioitinh as gender_desc, 
		1 as brand_status, 
		now() as register_dt, 
		now() as rec_created_dt, 
		now() as rec_updated_dt
		from 
		(
			select gioitinh
			from root_data.sanpham s 
			where gioitinh <> 'không có'
			group by gioitinh 
		) x 
		union 
		select -1 as key_gender_id, 
		'không có' as gender_name, 
		'không có' as gender_desc, 
		1 as brand_status, 
		now() as register_dt, 
		now() as rec_created_dt, 
		now() as rec_updated_dt ;
	
		/*
		 * STEP 3: đổ dữ liệu bảng strap_type
		 */
		truncate table stg.dim_strap_type;
		INSERT INTO stg.dim_strap_type
		(key_strap_type_id, strap_type_name, strap_type_desc, strap_type_status, register_dt, rec_created_dt, rec_updated_dt)
		select 
			rank() over(order by chatlieu) as key_strap_type_id, 
			chatlieu as strap_type_name, 
			chatlieu as strap_type_desc, 
			1 as strap_type_status, 
			now() as register_dt, 
			now() as rec_created_dt, 
			now() as rec_updated_dt
		from
		(
			select chatlieu
			from root_data.sanpham
			group by chatlieu
		)x;
	
		/*
		 * STEP 4: đổ dữ liệu bảng face_shape
		 */
		
		truncate table stg.dim_face_shape;
		INSERT INTO stg.dim_face_shape
		(key_face_shape_id, face_shape_name, face_shape_desc, face_shape_status, register_dt, rec_created_dt, rec_updated_dt)
		select 
			rank()over(order by mat_dong_ho) as key_face_shape_id, 
			mat_dong_ho as face_shape_name, 
			mat_dong_ho as face_shape_desc, 
			1 as face_shape_status, 
			now() as register_dt, 
			now() as rec_created_dt, 
			now() as rec_updated_dt
		from
		(
			select mat_dong_ho
			from root_data.sanpham
			where mat_dong_ho <> 'không có'
			group by mat_dong_ho
		)x
		union
		select -1 as key_face_shape_id, 
		'không có' as face_shape_name, 
		'không có' as face_shape_desc, 
		1 as face_shape_status, 
		now() as register_dt, 
		now() as rec_created_dt, 
		now() as rec_updated_dt ;
		
		/*
		 * STEP 5: đổ dữ liệu bảng nhóm sản phẩm
		 */
		truncate table stg.dim_category;
		INSERT INTO stg.dim_category
		(key_category_id, category_name, category_desc, category_status, register_dt, rec_created_dt, rec_updated_dt)
		select 
			rank()over(order by nhom_san_pham) as key_category_id, 
			nhom_san_pham as category_name, 
			nhom_san_pham as category_desc, 
			1 as category_status, 
			now() as register_dt, 
			now() as rec_created_dt, 
			now() as rec_updated_dt
		from root_data.sanpham
		group by nhom_san_pham;
	
		/*
		 * STEP 6 : đổ dữ liệu products 
		 */
		
		truncate table stg.dim_products ;
		INSERT INTO stg.dim_products
		(key_product_id, product_code, product_name, product_desc, key_brand_id, key_gender_id, key_strap_type_id, key_face_shape_id, key_category_id, campaign_key_id, product_status, register_dt, rec_created_dt, rec_updated_dt)
		select
			row_number() over(order by x.product_code) as key_product_id,
			x.product_code,
			x.product_name,
			null as product_desc,
			x.key_brand_id,
			x.key_gender_id,
			x.key_strap_type_id,
			x.key_face_shape_id,
			x.key_category_id,
			x.campaign_key_id,
			1 as product_status,
			now() as register_dt,
			now() as rec_created_dt,
			now() as rec_updated_dt
		
		from
		(
			select distinct
				lower(trim(s.masp)) as product_code,
				lower(trim(s.tensp)) as product_name,
				db.key_brand_id,
				dg.key_gender_id,
				dst.key_strap_type_id,
				dfc.key_face_shape_id,
				dc.key_category_id,
				dc2.campaign_key_id
			from root_data.sanpham s
			left join stg.dim_brands db
				on trim(lower(db.brand_name))
				 = trim(lower(s.thuonghieu))
			left join stg.dim_gender dg
				on trim(lower(dg.gender_name))
				 = trim(lower(s.gioitinh))
			left join stg.dim_strap_type dst
				on trim(lower(dst.strap_type_name))
				 = trim(lower(s.chatlieu))
			left join stg.dim_face_shape dfc
				on trim(lower(dfc.face_shape_name))
				 = trim(lower(s.mat_dong_ho))
			left join stg.dim_category dc
				on trim(lower(dc.category_name))
				 = trim(lower(s.nhom_san_pham))
			left join stg.dim_campaign dc2 
				on trim(lower(dc2.campaign_name))
				 = trim(lower(s.campaign_name))
		) x;
	
		/*
		 * STEP 7 : đổ dữ liệu district 
		 */
				
		truncate table stg.dim_district;
		INSERT INTO stg.dim_district
		(key_district_id, district_name, district_desc, register_dt)
		select 
			rank()over(order by tp_quan_huyen) as key_district_id, 
			tp_quan_huyen as district_name, 
			null as district_desc, 
			now() as register_dt
		from 
		(	
			select o.tp_quan_huyen 
			from root_data.orders o
			group by 1
		)x;
		
		/*
		 * STEP 8 : đổ dữ liệu ward 
		 */
				
		truncate table stg.dim_ward;
		INSERT INTO stg.dim_ward
		(key_ward_id, ward_name, ward_desc, register_dt)
		select 
			rank()over(order by quan) as key_ward_id, 
			quan as ward_name, 
			null as ward_desc, 
			now() as register_dt
		from 
		(	
			select o.quan 
			from root_data.orders o
			group by 1
		)x;
	
		/*
		 * STEP 9 : đổ dữ liệu city 
		 */
				
		truncate table stg.dim_city;
		INSERT INTO stg.dim_city
		(key_city_id, city_name, city_desc, register_dt)
		select 
			rank()over(order by tinh_thanh_pho) as key_city_id, 
			tinh_thanh_pho as city_name, 
			null as city_desc, 
			now() as register_dt
		from 
		(	
			select o.tinh_thanh_pho 
			from root_data.orders o
			group by 1
		)x;
	
				
		/*
		 * STEP 10 : đổ dữ liệu dim_customer 
		 */
		truncate table stg.dim_customer;
		INSERT INTO stg.dim_customer
		(key_customer_id, customer_id, customer_name, city_key, district_key, ward_key, customer_desc, register_dt)
		with customer_base as
		(
			select
				o.nguoi_mua as customer_id,
				max(o.ten_nguoi_nhan) as customer_name,
				max(o.tinh_thanh_pho) as city,
				max(o.tp_quan_huyen) as district,
				max(o.quan) as ward,
				min(o.ngay_dat_hang) as register_dt
			from root_data.orders o
			group by o.nguoi_mua
		)
		select
			row_number() over(order by c.register_dt,c.customer_id) as key_customer_id,
			c.customer_id,
			c.customer_name,
			dc.key_city_id as city_key,
			dd.key_district_id as district_key,
			dw.key_ward_id as ward_key,
			null as customer_desc,
			c.register_dt
		from customer_base c
		left join stg.dim_city dc on dc.city_name = c.city
		left join stg.dim_district dd on dd.district_name = c.district
		left join stg.dim_ward dw on dw.ward_name = c.ward;
		
		/*
		 * STEP 11 : đổ dữ liệu dim_variant_type 
		 */
		truncate table stg.dim_variants_type;
		INSERT INTO stg.dim_variants_type
		(variants_type_key_id, variants_type_name, variants_type_desc, register_dt)
		select
			rank()over(order by variants_type_name)variants_type_key_id, 
			variants_type_name, 
			null as variants_type_desc, 
			now() as register_dt
		from
		(
			select distinct
				trim(lower(ten_phan_loai)) as variants_type_name
			from root_data.phanloai
		)x;
	
		/*
		 * STEP 12 : đổ dữ liệu dim_variant_size 
		 */
		truncate table stg.dim_variants_size;
		INSERT INTO stg.dim_variants_size
		(variants_size_key_id, variants_size_name, variants_size_desc, register_dt)
		select
			rank()over(order by variants_size_name) as variants_size_key_id, 
			variants_size_name, 
			null as variants_size_desc, 
			now() as register_dt
		from
		(
			select distinct
			trim(lower("size")) as variants_size_name
			from root_data.phanloai
		)x;
		
		/*
		 * STEP 12 : đổ dữ liệu dim_variants
		 */
		truncate table stg.dim_variants;
		INSERT INTO stg.dim_variants
		(key_variants_id,key_product_id ,variants_code, variants_desc, variants_type_key_id, variants_size_key_id, variants_status, unit_cost, sale_price, register_dt, rec_created_dt, rec_updated_dt)
		select
			row_number() over(order by x.variants_code) as key_variants_id,
			x.key_product_id,
			x.variants_code,
			null as variants_desc,
			x.variants_type_key_id,
			x.variants_size_key_id,
			1 as variants_status,
			x.unit_cost,
			x.sale_price,
			now() as register_dt,
			now() as rec_created_dt,
			now() as rec_updated_dt
		from
		(
			select distinct
				dp.key_product_id,
				lower(trim(p.maphanloai)) as variants_code,
				dvt.variants_type_key_id,
				dvs.variants_size_key_id,
				p.gia_nhap as unit_cost,
				p.giaban as sale_price
			from root_data.phanloai p
			left join stg.dim_variants_type dvt
				on trim(lower(dvt.variants_type_name))
				 = trim(lower(p.ten_phan_loai))
			left join stg.dim_variants_size dvs
				on trim(lower(dvs.variants_size_name))
				 = trim(lower(p."size"))
			left join stg.dim_products dp
				on trim(lower(dp.product_code))
				 = trim(lower(p.masp))
		) x;
		
		/*
		 * STEP 13 : đổ dữ liệu dim_campaign_group
		 */
		truncate table stg.dim_campaign_group;
		INSERT INTO stg.dim_campaign_group
		(campaign_group_key_id, campaign_group_name, campaign_group_desc, register_dt)
		select
			row_number()over(order by phuong_thuc_dau_thau) as campaign_group_key_id, 
			phuong_thuc_dau_thau as campaign_group_name, 
			null as campaign_group_desc, 
			now() as register_dt
		from
		(
			select phuong_thuc_dau_thau
			from root_data.campaign c
			group by phuong_thuc_dau_thau
		)x;
	
		/*
		 * STEP 13 : đổ dữ liệu dim_campaign_status
		 */
		truncate table stg.dim_campaign_status;
		INSERT INTO stg.dim_campaign_status
		(campaign_status_key_id, campaign_status, update_dt)
		select
			case
			when trang_thai = 'Đã dừng' then 0 else 1 end as campaign_status_key_id, 
			trang_thai as campaign_status, 
			now() as update_dt
		from
		(
			select root_data.campaign.trang_thai
			from root_data.campaign 
			group by 1
		)x;
	
		/*
		 * STEP 13 : đổ dữ liệu dim_campaign
		 */	
		truncate table stg.dim_campaign;
		INSERT INTO stg.dim_campaign
		(campaign_key_id,campaign_name,campaign_group_key_id,campaign_status_key_id,start_dt,end_dt,is_unlimited)
		select
			row_number() over(order by c.ten_dich_vu_hien_thi) as campaign_key_id, 
			c.ten_dich_vu_hien_thi as campaign_name, 
			dg.campaign_group_key_id, 
			ds.campaign_status_key_id, 
			to_timestamp(
				c.ngay_bat_dau,
				'DD/MM/YYYY HH24:MI:SS'
			) as start_dt, 
			case
				when c.ngay_ket_thuc = 'Không giới hạn' then null 
				else to_timestamp(
					c.ngay_ket_thuc,
					'DD/MM/YYYY HH24:MI:SS'
				) end as end_dt, 
			case
				when c.ngay_ket_thuc = 'Không giới hạn'
				then 1
				else 0
			end as is_unlimited
		from root_data.campaign c
		left join stg.dim_campaign_group dg
			on dg.campaign_group_name = c.phuong_thuc_dau_thau
		left join stg.dim_campaign_status ds
			on ds.campaign_status = c.trang_thai
		group by 2,3,4,5,6,7;
	
		/*
		 * STEP 14 : đổ dữ liệu dim_order_status
		 */	
			
		truncate table stg.dim_order_status;
		INSERT INTO stg.dim_order_status
		(order_status_id, order_status)
		select 
			case
			when order_status = 'Đã hủy' then 0
			when order_status = 'Hoàn trả' then -1
			when order_status = 'Chờ giao hàng' then 1
			when order_status = 'Đang giao' then 2
			when order_status = 'Đã giao' then 3
			when order_status = 'Đã nhận được hàng' then 4
			when order_status = 'Đã nhận hàng chờ refund' then 5
			when order_status = 'Hoàn thành' then 6
			end as order_status_id,
			order_status
		from
		(
			select normalized_text as order_status
			from
			(
				select
					o.trang_thai_don_hang as raw_text,
					o.trang_thai_tra_hang_hoan_tien,
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
					end as normalized_text
				from root_data.orders o
			)a
			where normalized_text is not null
			group by 1
		)x;
	
		/*
		 * STEP 15 : đổ dữ liệu dim_order_cancel_reason
		 */
		truncate table stg.dim_order_cancel_reason;
		INSERT INTO stg.dim_order_cancel_reason
		(order_cancel_reason_id, order_cancel_reason)
		select
			case
				when cancel_reason is null then 0
				else row_number()over(order by cancel_reason) 
			end as order_cancel_reason_id, 
			cancel_reason as order_cancel_reason
		from
		(
			select o.ly_do_huy as cancel_reason
			from root_data.orders o
			group by 1
		)a;
	
		/*
		 * STEP 15 : đổ dữ liệu dim_payment_method
		 */
		truncate table stg.dim_payment_method;
		INSERT INTO stg.dim_payment_method
		(payment_method_id, payment_method)
		select 
			row_number()over() as payment_method_id, 
			payment_method
		from
		(
			select root_data.orders.phuong_thuc_thanh_toan as payment_method
			from root_data.orders
			group by 1
		)a;
		
		/*
		 * STEP 16 : đổ dữ liệu dim_date
		 */
		truncate table stg.dim_date;
		INSERT INTO stg.dim_date
		(
		    date_key,
		    full_date,
		    day_of_month,
		    day_of_week,
		    day_name,
		    week_of_year,
		    month_number,
		    month_name,
		    quarter_number,
		    year_number,
		    is_weekend
		)
		select
		    to_char(d::date, 'YYYYMMDD')::int as date_key,
		    d::date as full_date,
		    extract(day from d) as day_of_month,
		    extract(isodow from d) as day_of_week,
		    to_char(d, 'Day') as day_name,
		    extract(week from d) as week_of_year,
		    extract(month from d) as month_number,
		    to_char(d, 'Month') as month_name,
		    extract(quarter from d) as quarter_number,
		    extract(year from d) as year_number,
		    case
		        when extract(isodow from d) in (6,7)
		        then true
		        else false
		    end as is_weekend
		from generate_series
		(
		    '2020-01-01'::date,
		    '2035-12-31'::date,
		    interval '1 day'
		) d;
	
		/*
		 * STEP 17 : đổ dữ liệu dim_profit_and_loss
		 */
		truncate table stg.dim_profit_and_loss;
		INSERT INTO stg.dim_profit_and_loss
		(pl_id, pl_code, pl_type, pl_desc)
		select
			row_number()over(order by pl_type) as pl_id, 
			pl_code, 
			pl_type, 
			null as pl_desc
		from
		(
			select
				fee_type_name as pl_code,
				'D' as pl_type
			from stg.dim_fee_type
			union all
			select
				'paid_revenue' as pl_code,
				'C' as pl_type
			union all
			select
				'pending_revenue' as pl_code,
				'C' as pl_type
			union all
			select
				'unit_cost' as pl_code,
				'D' as pl_type
		)x;
	
		/*
		 * STEP 18: đổ dữ liệu bảng dim_products_metrics
		 */
		truncate table stg.dim_products_metrics;
		insert into stg.dim_products_metrics 
		(metric_id,metric_code,metric_desc,metric_group,metric_direction)
		values
		    (1, 'views_count', 'Total product views', 'traffic', 'p'),
		    (2, 'clicks', 'Total product clicks', 'traffic', 'p'),
		    (3, 'exit_count', 'Total exits from product page', 'engagement', 'n'),
		    (4, 'add_to_cart', 'Total add to cart actions', 'engagement', 'p'),
		    (5, 'orders', 'Total orders', 'sales', 'p');
		
		/*
		 * STEP 19: đổ dữ liệu bảng dim_customer_metrics
		 */	
		truncate table stg.dim_customer_metrics;
		INSERT INTO stg.dim_customer_metrics
		(metric_id, metric_code, metric_name, metric_group, metric_type, description, sort_order)
		values
		-- customer
		(1, 'active_customers', 'Active Customers', 'customer', 'count', 'customers with orders in month', 1),
		(2, 'new_customers', 'New Customers', 'customer', 'count', 'first time purchasing customers', 2),
		(3, 'returning_customers', 'Returning Customers', 'customer', 'count', 'customers who returned to purchase', 3),
		-- order
		(4, 'total_orders', 'Total Orders', 'order', 'count', 'total orders', 4),
		(5, 'completed_orders', 'Completed Orders', 'order', 'count', 'completed orders', 5),
		(6, 'canceled_orders', 'Canceled Orders', 'order', 'count', 'canceled orders', 6),
		-- revenue
		(7, 'total_revenue', 'Total Revenue', 'revenue', 'currency', 'customer revenue', 7),
		(8, 'total_cost', 'Total Cost', 'revenue', 'currency', 'customer cost', 8),
		(9, 'total_profit', 'Total Profit', 'revenue', 'currency', 'customer profit', 9),
		-- behavior
		(10, 'avg_order_value', 'Average Order Value', 'behavior', 'currency', 'average order value', 10),
		(11, 'purchase_frequency', 'Purchase Frequency', 'behavior', 'number', 'purchase frequency', 11),
		(12, 'days_since_last_order', 'Days Since Last Order', 'behavior', 'number', 'days from previous order', 12),
		(13, 'lifetime_orders', 'Lifetime Orders', 'behavior', 'number', 'total lifetime orders', 13),
		(14, 'lifetime_revenue', 'Lifetime Revenue', 'behavior', 'currency', 'total lifetime revenue', 14),
		-- flags
		(15, 'is_new_customer', 'Is New Customer', 'flag', 'boolean', '1 if first purchase month', 15),
		(16, 'is_returning_customer', 'Is Returning Customer', 'flag', 'boolean', '1 if repeat customer', 16),
		(17, 'is_active_customer', 'Is Active Customer', 'flag', 'boolean', '1 if customer active in month', 17);
	
		/*
		 * STEP 20: đổ dữ liệu bảng dim_monthly_risk_management_metrics 
		 */	
		truncate table stg.dim_monthly_risk_management_metrics;
		insert into stg.dim_monthly_risk_management_metrics
		(metrics_id,metrics_code,metrics_desc,metrics_group,format_type,sort_order,is_active
		)
		values
		-- =========================
		-- ORDER VOLUME
		-- =========================
		(1, 'total_orders', 'Total number of orders', 'order_volume', 'number', 1, 1),
		(2, 'completed_orders', 'Orders completed successfully', 'order_volume', 'number', 2, 1),
		(3, 'canceled_orders', 'Orders canceled before completion', 'order_volume', 'number', 3, 1),
		(4, 'delivered_orders', 'Orders delivered to customers', 'order_volume', 'number', 4, 1),
		
		-- =========================
		-- REFUND / RETURN
		-- =========================
		(5, 'refund_requested_orders', 'Orders with refund requests', 'refund_risk', 'number', 5, 1),
		(6, 'approved_refund_orders', 'Refund requests approved', 'refund_risk', 'number', 6, 1),
		(7, 'disputed_refund_orders', 'Refund disputes resolved in seller favor', 'refund_risk', 'number', 7, 1),
		(8, 'returned_orders', 'Orders returned by customers', 'refund_risk', 'number', 8, 1),
		
		-- =========================
		-- FINANCIAL METRICS
		-- =========================
		(9, 'total_gmv', 'Total gross merchandise value', 'financial', 'currency', 9, 1),
		(10, 'completed_gmv', 'GMV from completed orders', 'financial', 'currency', 10, 1),
		(11, 'canceled_gmv', 'GMV lost from canceled orders', 'financial', 'currency', 11, 1),
		(12, 'refund_requested_gmv', 'GMV under refund requests', 'financial', 'currency', 12, 1),
		(13, 'approved_refund_gmv', 'GMV refunded to customers', 'financial', 'currency', 13, 1);
	
	end;
	$procedure$ 
	;
	
	--call stg.prc_insert_dim_tables()