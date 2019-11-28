-- œ≥Î¸„Ë œƒ‘Œ (hr_taxLimit)
select 
	'ID' ID
	,'code' code
	,'name' name
	,'taxLimitType' taxLimitType
	,'size' size
	,'codeForReport' codeForReport
	,'dateFrom' dateFrom
	,'dateTo' dateTo
union all
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