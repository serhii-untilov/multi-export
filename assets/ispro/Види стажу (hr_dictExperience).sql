-- Види стажу (hr_dictExperience)
-- ID;code;name;methodExpID;dateFrom;dateTo
select
	'1' ID
	,'1' code
	,'Загальний стаж' name
	,null methodExpID -- !!!
	,'1876-12-31' dateFrom
	,'9999-12-31' dateTo
where exists (select null from KPUC1 where Kpu_DtObSt > '1876-12-31')
union all
select
	'2' ID
	,'2' code
	,'Безперервний стаж' name
	,null methodExpID -- !!!
	,'1876-12-31' dateFrom
	,'9999-12-31' dateTo
where exists (select null from KPUC1 where Kpu_DtNpSt > '1876-12-31')
union all
select
	'3' ID
	,'3' code
	,'Стаж на підприємстві' name
	,null methodExpID -- !!!
	,'1876-12-31' dateFrom
	,'9999-12-31' dateTo
where exists (select null from KPUC1 where Kpu_DtOrgSt > '1876-12-31')
union all
select
	'4' ID
	,'4' code
	,'Страховий стаж' name
	,null methodExpID -- !!!
	,'1876-12-31' dateFrom
	,'9999-12-31' dateTo
where exists (select null from KPUC1 where Kpu_DtSrSt > '1876-12-31')
union all
select
	'5' ID
	,'5' code
	,'Галузевий стаж' name
	,null methodExpID -- !!!
	,'1876-12-31' dateFrom
	,'9999-12-31' dateTo
where exists (select null from KPUC1 where Kpu_DtOtrSt > '1876-12-31')
union all
select
	'6' ID
	,'6' code
	,'Стаж держслужбовця' name
	,null methodExpID -- !!!
	,'1876-12-31' dateFrom
	,'9999-12-31' dateTo
where exists (select null from KPUC1 where Kpu_DtGS > '1876-12-31')
union all
select
	'7' ID
	,'7' code
	,'Безперервний стаж держслужбовця' name
	,null methodExpID -- !!!
	,'1876-12-31' dateFrom
	,'9999-12-31' dateTo
where exists (select null from KPUC1 where Kpu_DtGSNp > '1876-12-31')
union all
select
	cast(paystg_cd + 10 as varchar) ID
	,cast(paystg_cd + 10 as varchar) code
	,pspr.spr_nm name
	,null methodExpID -- !!!
	,cast(cast(paystg_datn as date) as varchar) dateFrom
	,cast(cast(case when paystg_datk <= '1876-12-31' then '9999-12-31' else paystg_datk end as date) as varchar) dateTo
from PAYSTG
inner join PSPR on pspr.SprSpr_Cd = 680984 and pspr.Spr_Cd = paystg.paystg_cd