-- Види доходу ПДФО (hr_dictTaxIndivid)
/*
select 
	'ID' ID
	,'code' code
	,'name' name
	,'dateFrom' dateFrom
	,'dateTo' dateTo
	,'taxBreaks' taxBreaks
union all
*/
select 
	cast(spr_cd as varchar) ID	
	,cast(spr_cd as varchar) code	
	,spr_nm name	
	,null dateFrom	
	,null dateTo	
	,null taxBreaks
from pspr
where sprspr_cd = 133666

