--check pending cost
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
--profit & loss
select
	substring(fmpal.date_key,1,6) as month_key,
	dpal.pl_code,
	dpal.pl_type,
	fmpal.amount
from stg.fact_monthly_profit_and_loss fmpal
join stg.dim_profit_and_loss dpal
	on dpal.pl_id = fmpal.pl_id
order by 1 desc,2

--product
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
order by 1,2,3,4

--customer
select
	fcmm.month_key,
	fcmm.customer_id,
	fcmm.city,
	fcmm.district,
	dcm.metric_code,
	dcm.description,
	fcmm.value
from stg.fact_customer_monthly_metrics fcmm
join stg.dim_customer_metrics dcm 
	on dcm.metric_id = fcmm.metric_id
order by 1,2,3,4,5

--risk
select 
	fmrm.month_key,
	fmrm.city,
	fmrm.district,
	db.brand_name,
	dpm.payment_method,
	dmrmm.metrics_code,
	dmrmm.metrics_desc,
	fmrm.metrics_value as total_amt
from stg.fact_monthly_risk_management fmrm
join stg.dim_brands db 
	on db.key_brand_id = fmrm.key_brand_id
join stg.dim_payment_method dpm 
	on dpm.payment_method_id = fmrm.payment_method_id
join stg.dim_monthly_risk_management_metrics dmrmm 
	on dmrmm.metrics_id = fmrm.metrics_id
order by 1,2,3,4,5,6