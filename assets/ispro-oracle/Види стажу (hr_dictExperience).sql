-- Види стажу (hr_dictExperience)
-- ID;code;name;methodExpID;dateFrom;dateTo
select
	'1' "ID"
	,'1' "code"
	,'Загальний стаж' "name"
	,'' "methodExpID" -- !!!
	,'1876-12-31' "dateFrom"
	,'9999-12-31' "dateTo"
from dual
where exists (select null from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 where Kpu_DtObSt > TO_DATE('1876-12-31', 'YYYY-MM-DD'))	
union all
select
	'2' "ID"
	,'2' "code"
	,'Безперервний стаж' "name"
	,'' "methodExpID" -- !!!
	,'1876-12-31' "dateFrom"
	,'9999-12-31' "dateTo"
from dual
where exists (select null from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 where Kpu_DtNpSt > TO_DATE('1876-12-31', 'YYYY-MM-DD'))
union all
select
	'3' "ID"
	,'3' "code"
	,'Стаж на підприємстві' "name"
	,'' "methodExpID" -- !!!
	,'1876-12-31' "dateFrom"
	,'9999-12-31' "dateTo"
from dual
where exists (select null from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 where Kpu_DtOrgSt > TO_DATE('1876-12-31', 'YYYY-MM-DD'))
union all
select
	'4' "ID"
	,'4' "code"
	,'Страховий стаж' "name"
	,'' methodExpID -- !!!
	,'1876-12-31' "dateFrom"
	,'9999-12-31' "dateTo"
from dual
where exists (select null from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 where Kpu_DtSrSt > TO_DATE('1876-12-31', 'YYYY-MM-DD'))
union all
select
	'5' "ID"
	,'5' "code"
	,'Галузевий стаж' "name"
	,'' "methodExpID" -- !!!
	,'1876-12-31' "dateFrom"
	,'9999-12-31' "dateTo"
from dual
where exists (select null from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 where Kpu_DtOtrSt > TO_DATE('1876-12-31', 'YYYY-MM-DD'))
union all
select
	'6' "ID"
	,'6' "code"
	,'Стаж держслужбовця' "name"
	,'' "methodExpID" -- !!!
	,'1876-12-31' "dateFrom"
	,'9999-12-31' "dateTo"
from dual
where exists (select null from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 where Kpu_DtGS > TO_DATE('1876-12-31', 'YYYY-MM-DD'))
union all
select
	'7' "ID"
	,'7' "code"
	,'Безперервний стаж держслужбовця' "name"
	,'' "methodExpID" -- !!!
	,'1876-12-31' "dateFrom"
	,'9999-12-31' "dateTo"
from dual
where exists (select null from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 where Kpu_DtGSNp > TO_DATE('1876-12-31', 'YYYY-MM-DD'))
union all	
select
	TO_CHAR(paystg_cd + 10) "ID"
	,TO_CHAR(paystg_cd + 10) "code"
	,pspr.spr_nm "name"
	,'' "methodExpID" -- !!!
	,TO_CHAR(paystg_datn, 'YYYY-MM-DD') dateFrom
	,case when paystg_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '9999-12-31' else TO_CHAR(paystg_datk, 'YYYY-MM-DD') end "dateTo"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.PAYSTG
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.PSPR on pspr.SprSpr_Cd = 680984 
	and pspr.Spr_Cd = paystg.paystg_cd
