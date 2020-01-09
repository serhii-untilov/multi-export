-- Категорії персоналу (hr_dictStaffCat)
/*BEGIN-OF-HEAD*/
select 'ID' ID,	'code' code, 'name' name, 'description' description, 'accCategory' accCategory
union all
/*END-OF-HEAD*/
select 
	cast(spr_cd as varchar) ID	
	,cast(spr_cd as varchar) code	
	,spr_nm name	
	,cast(spr_cd as varchar) + ' ' + spr_nm description	
	,null accCategory
from pspr
where sprspr_cd = 549