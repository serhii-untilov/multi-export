-- Категорії застрахованих осіб (hr_dictCategoryECB)
select
	cast(spr_cd as varchar) ID
	,cast(spr_cd as varchar) code
	,spr_nm name
	,null dictTypeTaxECBID
	,cast(spr_cd as varchar) + ' ' + spr_nm description
from pspr
where sprspr_cd = 521