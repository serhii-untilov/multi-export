-- Довідник Науковий ступінь (hr_dictDegree)
select
	spr_cd "ID",
	spr_cd "code",
	spr_nm "name"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr
Where sprspr_cd = 681080
