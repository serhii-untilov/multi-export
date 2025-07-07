-- Категорії застрахованих осіб (hr_dictCategoryECB)
select
	cast(spr_cd as varchar) ID
	,cast(spr_cd as varchar) code
	,spr_nm name
	,null dictTypeTaxECBID
	,cast(spr_cd as varchar) + ' ' + spr_nm description
from pspr
where sprspr_cd = 521
union all
select
	'9999' ID
	,'25' code
	,'Держслужбовці' name
	,null dictTypeTaxECBID
	,'25 Держслужбовці' description
from dual
where not exists (
	select 1
	from pspr
	where sprspr_cd = 521 and spr_cd = '25'
)