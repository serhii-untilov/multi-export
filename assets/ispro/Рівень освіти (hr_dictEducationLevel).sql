-- Рівень освіти (hr_dictEducationLevel)
/*BEGIN-OF-HEAD*/
select 'ID' id, 'code' code, 'name' name
union all
/*END-OF-HEAD*/
select cast(spr_cd as varchar) ID
	,cast(spr_cd as varchar) code
	,spr_nm name
from /*SYS_SCHEMA*/i711_sys.dbo.sspr
where sprspr_cd = 656131
and spr_cdlng = 2
union all
select
	'0' ID
	,'0' code
	,'<не визначено>' name
where not exists (
	select null
	from /*SYS_SCHEMA*/i711_sys.dbo.sspr
	where sprspr_cd = 656131
	and spr_cdlng = 2
	and spr_cd = 0
)
