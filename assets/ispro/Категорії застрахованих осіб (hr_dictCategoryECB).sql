-- Категорії застрахованих осіб (hr_dictCategoryECB)
/*BEGIN-OF-HEAD*/
select 'ID' ID,	'code' code, 'name' name, 'dictTypeTaxECBID' dictTypeTaxECBID, 'description' description
union all
/*END-OF-HEAD*/
select 
	cast(spr_cd as varchar) ID	
	,cast(spr_cd as varchar) code	
	,spr_nm name
	,null dictTypeTaxECBID
	,cast(spr_cd as varchar) + ' ' + spr_nm description	
from pspr
where sprspr_cd = 521