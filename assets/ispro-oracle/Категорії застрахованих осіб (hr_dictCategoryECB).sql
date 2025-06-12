-- Категорії застрахованих осіб (hr_dictCategoryECB)
select 
	spr_cd "ID"	
	,spr_cd "code"	
	,spr_nm "name"
	,'null' "dictTypeTaxECBID"
	,TO_CHAR(spr_cd) || ' ' || spr_nm "description"	
from /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr
where sprspr_cd = 521