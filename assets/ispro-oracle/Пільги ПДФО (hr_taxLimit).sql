-- Пільги ПДФО (hr_taxLimit)
select
	spr_cd "ID"
	,spr_cd "code"
	,spr_nm "name"
	,'' "taxLimitType"
	,'' "size"
	,'' "codeForReport"
	,'' "dateFrom"
	,'' "dateTo"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr
where sprspr_cd = 133667
