-- Рівень освіти (hr_dictEducationLevel)
select TO_CHAR(spr_cd) "ID"
	,TO_CHAR(spr_cd) "code"
	,spr_nm "name"
from /*SYS_SCHEMA*/ISPRO_8_PROD_SYS.sspr
where sprspr_cd = 656131
and spr_cdlng = 2
union all
select
	'0' "ID"
	,'0' "code"
	,'<не визначено>' "name"
from dual
where not exists (
	select null
	from /*SYS_SCHEMA*/ISPRO_8_PROD_SYS.sspr
	where sprspr_cd = 656131
	and spr_cdlng = 2
	and spr_cd = 0
)
