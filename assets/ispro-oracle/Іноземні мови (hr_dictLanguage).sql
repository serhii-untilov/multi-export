-- Іноземні мови (hr_dictLanguage)
select
	spr_cd "ID",
	spr_cd "code",
	spr_nmlong "name"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr
where sprspr_cd = 680965