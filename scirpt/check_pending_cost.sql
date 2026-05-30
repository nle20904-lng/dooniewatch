select
	sum(total_price) as total_price,
	sum(total_fee) as total_fee,
	sum(total_price) - sum(total_fee) as pending_revenue
from 
(
	select
		fto.transaction_order_id,
		fto.order_id,
		fto.order_complete_dt,
		fto.total_price,
		sum(fof.amount) as total_fee
	from stg.fact_txn_orders fto 
	join stg.fact_order_fee fof
		on fof.order_id = fto.order_id
	where fto.order_status_id in (2,3)
	group by 1,2,3,4
)


select 
	fmpp.month_key,
	db.brand_name,
	dc.category_name,
	dpm.metric_code,
	fmpp.amount
from stg.fact_monthly_products_performance fmpp
join stg.dim_products_metrics dpm 
	on dpm.metric_id = fmpp.metric_id
join stg.dim_brands db 
	on db.key_brand_id = fmpp.brand_id
join stg.dim_category dc 
	on dc.key_category_id = fmpp.category_id












