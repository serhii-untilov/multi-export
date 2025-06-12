-- Види доходу ПДФО (hr_dictTaxIndivid)
select 
	TO_CHAR(spr_cd) "ID"	
	,TO_CHAR(spr_cd) "code"
	,spr_nm "name"	
	,'2004-01-01' "dateFrom"
	,'9999-12-31' "dateTo"
	,'' "taxBreaks"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr
where sprspr_cd = 133666
