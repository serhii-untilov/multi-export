-- Довідник Пільги ПДФО
select base.uuid_bigint(id::text) "ID",
	alias "code",
	name,
	case when alias = '15' then '2'
		when alias = '15/2' then '2' 
		when alias = '2' then '2'
		when alias = '2/1' then '2'
		when alias = '2/2' then '2'
		when alias = '2/3' then '2'
		when alias = '2/4' then '2'
		when alias = '3' then '2'
		when alias = '4' then '2'
		when alias = '4/2' then '2'
		when alias = '4/4' then '2'
		else '1' end "taxLimitType",
	case when alias = '15' then '2.5'
		when alias = '15/2' then '3.5' 
		when alias = '2' then '1.5'
		when alias = '2/1' then '1.5'
		when alias = '2/2' then '1.5'
		when alias = '2/3' then '1.5'
		when alias = '2/4' then '1.5'
		when alias = '3' then '1.5'
		when alias = '4' then '1'
		when alias = '4/2' then '1'
		when alias = '4/4' then '1'
		else (percent_bonus::float / 100)::text end "size",
	sign_benefits "codeForReport",
	'2004-01-01' "dateFrom",
	'9999-12-31' "dateTo"
from salary.tax_bonus
order by alias;
