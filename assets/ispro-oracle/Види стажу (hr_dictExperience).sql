-- ���� ����� (hr_dictExperience)
-- ID;code;name;methodExpID;dateFrom;dateTo
select
	'1' "ID"
	,'1' "code"
	,'��������� ����' "name"
	,'' "methodExpID" -- !!!
	,'1876-12-31' "dateFrom"
	,'9999-12-31' "dateTo"
from dual
where exists (select null from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 where Kpu_DtObSt > TO_DATE('1876-12-31', 'YYYY-MM-DD'))	
union all
select
	'2' "ID"
	,'2' "code"
	,'������������ ����' "name"
	,'' "methodExpID" -- !!!
	,'1876-12-31' "dateFrom"
	,'9999-12-31' "dateTo"
from dual
where exists (select null from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 where Kpu_DtNpSt > TO_DATE('1876-12-31', 'YYYY-MM-DD'))
union all
select
	'3' "ID"
	,'3' "code"
	,'���� �� ���������' "name"
	,'' "methodExpID" -- !!!
	,'1876-12-31' "dateFrom"
	,'9999-12-31' "dateTo"
from dual
where exists (select null from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 where Kpu_DtOrgSt > TO_DATE('1876-12-31', 'YYYY-MM-DD'))
union all
select
	'4' "ID"
	,'4' "code"
	,'��������� ����' "name"
	,'' methodExpID -- !!!
	,'1876-12-31' "dateFrom"
	,'9999-12-31' "dateTo"
from dual
where exists (select null from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 where Kpu_DtSrSt > TO_DATE('1876-12-31', 'YYYY-MM-DD'))
union all
select
	'5' "ID"
	,'5' "code"
	,'��������� ����' "name"
	,'' "methodExpID" -- !!!
	,'1876-12-31' "dateFrom"
	,'9999-12-31' "dateTo"
from dual
where exists (select null from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 where Kpu_DtOtrSt > TO_DATE('1876-12-31', 'YYYY-MM-DD'))
union all
select
	'6' "ID"
	,'6' "code"
	,'���� �������������' "name"
	,'' "methodExpID" -- !!!
	,'1876-12-31' "dateFrom"
	,'9999-12-31' "dateTo"
from dual
where exists (select null from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 where Kpu_DtGS > TO_DATE('1876-12-31', 'YYYY-MM-DD'))
union all
select
	'7' "ID"
	,'7' "code"
	,'������������ ���� �������������' "name"
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
