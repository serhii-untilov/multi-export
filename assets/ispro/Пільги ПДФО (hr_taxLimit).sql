-- Пільги ПДФО (hr_taxLimit)
select
	cast(spr_cd as varchar) ID
	,cast(spr_cd as varchar) code
	,spr_nm name
	,null taxLimitType
	,null size
	,null codeForReport
	,null dateFrom
	,null dateTo
from pspr
where sprspr_cd = 133667