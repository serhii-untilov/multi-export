-- Категорії персоналу (hr_dictStaffCat)
select
	spr_cd "ID",
	spr_cd "code",
	spr_nm "name",
	TO_CHAR (spr_cd) || ' ' || spr_nm "description",
	'null' "accCategory"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr
where sprspr_cd = 549
