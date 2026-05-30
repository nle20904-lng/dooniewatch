-- update cost_history
CREATE TABLE stg.dim_variant_cost_history (
    key_variant_cost_history_id BIGSERIAL,
    key_variants_id INT8 NOT NULL,
    variants_code VARCHAR(1024) NOT NULL,
    unit_cost NUMERIC(18,2) NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP NULL,
    is_current BOOLEAN NOT NULL
);

truncate table stg.dim_variant_cost_history

--sau này nếu muốn thay đổi giá cost
--step 1: đổi is_current của cái đó thành false và set lại valid_to
update stg.dim_variant_cost_history
set 
	is_current = false,
	valid_to = now()
where stg.dim_variant_cost_history.variants_code like '%...%'
and is_current = true;
--step 2: nhập code muốn thay đổi cost
INSERT INTO stg.dim_variant_cost_history
(key_variants_id, variants_code, unit_cost, valid_from, valid_to, is_current)
select *
from
(
	select
		dv.key_variants_id, 
		dv.variants_code,
		case
			when dv.variants_code like '%...%' 
				then ... *
					case when dv.variants_code like '%doi' then 2 else 1 end
		end as unit_cost,
		now() as valid_from, 
		null as valid_to, 
		true is_current
	from dim_variants dv
)x
where x.unit_cost is not null 

/*
union
select
	y.key_variants_id, 
	y.variants_code, 
	dv2.unit_cost, 
	y.valid_from, 
	y.valid_to, 
	y.is_current
from
(
	select 
		x.key_variants_id, 
		x.variants_code, 
		x.unit_cost, 
		x.valid_from, 
		x.valid_to, 
		x.is_current
	from
	(
		select
			dv.key_variants_id, 
			dv.variants_code,
			case
				when dv.variants_code like '%wro%' 
					then 70000 *
						case when dv.variants_code like '%doi' then 2 else 1 end
				when dv.variants_code like '%mvd%' 
					then 200000 *
						case when dv.variants_code like '%doi' then 2 else 1 end
				when dv.variants_code like '%dw%' 
					then 170000 *
						case when dv.variants_code like '%doi' then 2 else 1 end
				when dv.variants_code like '%ori%' 
					then 200000 *
						case when dv.variants_code like '%doi' then 2 else 1 end
			end as unit_cost,
			'2024-05-01'::timestamp as valid_from, 
			now() as valid_to, 
			true is_current
		from dim_variants dv
	)x
	where x.unit_cost is null 
)y
join dim_variants dv2 on dv2.variants_code = y.variants_code
*/
