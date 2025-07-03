-- Категорії персоналу (hr_dictStaffCat)
select
	cast(spr_cd as varchar) ID
	,cast(spr_cd as varchar) code
	,spr_nm name
	,cast(spr_cd as varchar) + ' ' + spr_nm description
	,null accCategory
from pspr
where sprspr_cd = 549