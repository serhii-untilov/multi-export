-- Види доходу ПДФО (hr_dictTaxIndivid)
select
	cast(spr_cd as varchar) ID
	,cast(spr_cd as varchar) code
	,spr_nm name
	,null dateFrom
	,null dateTo
	,null taxBreaks
from pspr
where sprspr_cd = 133666

