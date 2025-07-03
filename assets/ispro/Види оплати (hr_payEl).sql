﻿-- Види оплати (hr_payEl)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
select
	cast(Vo_Cd as varchar) ID,
	Vo_cdchr code,
	pspr.spr_nm name,
	cast(vo_met as varchar) methodID
	,cast(Vo_Cd as varchar) + ' ' + pspr.spr_nm description
	,null dateFrom
	,null dateTo
	,cast(Vo_Rnd + 1 as varchar) roundUpTo
	,cast(case when Vo_NoClc = 1 then 0 else 1 end as varchar) isAutoCalc
	,cast(case when Vo_NoReClc = 1 then 0 else 1 end as varchar) isRecalculate
	,cast(case
		when vo_grp = 1 and So_Tim = 0 then 'DAY'
		when vo_grp = 1 and So_Tim <> 0 then 'HOUR'
		when vo_grp in (6, 9) and Bo_Zar = 0 then 'DAY'
		when vo_grp in (6, 9) and Bo_Zar <> 0 then 'HOUR'
		else null
		end as varchar) calcProportion
	,cast(case
		when vo_grp = 1 then 'PLAN' -- СО
		when vo_met = 8 then 'PLAN' -- доплата за замещение
		when vo_met = 9 then 'PLAN' -- доплата за вечерние
		when vo_met = 10 then 'PLAN' -- доплата за ночные
		when vo_met = 11 then 'PLAN' -- доплата за работу сверхурочно
		when vo_met = 12 then 'PLAN' -- доплата за работу в праздничные
		when vo_met = 13 then 'PLAN' -- доплата за работу в выходной
		when vo_met = 14 then 'PLAN' -- льготные подросткам
		when vo_met = 37 then 'PLAN' -- надбавка за ранг
		when vo_met = 109 then 'FACT' -- ндбавка от среднего заработка
		when vo_met = 110 then 'FACT' -- доплата до среднего заработка
		when vo_met = 216 then 'PLAN' -- доплата за совмещение
		when vo_met = 266 then 'FACT' -- доплата до МЗ
		when vo_grp = 2 and (vo_prz & 512) <> 0 then 'FACT' -- надбавки от факт заработка
		when vo_grp = 2 and (vo_prz & 512) = 0 then 'PLAN' -- надбавки от план заработка
		when Vo_PlZr = 0 then 'FACT'
		else 'PLAN'
		end as varchar) calcSumType
	,cast(case
		when Vo_Grp = 1 then null
		when Vo_Grp = 2 then 'SALARY'
		when Vo_Grp = 4 and Vo_PlZr <> 0 then 'SALARY'
		when Vo_Grp = 4 and Vo_PlZr = 0 then 'SALARY'
		when Vo_RpUp = 0 then 'SALARY'
		else 'CALC'
		end as varchar) periodType
	,cast(Vo_Stj as varchar) dictExperienceID
	,cast(case when vo_grp = 5 then case when Ot_QtMon > 0 then Ot_QtMon else 12 end
		when vo_grp = 6 then case when Bo_QtMon > 0 then Bo_QtMon else 12 end
		when vo_grp = 9 then 2 end as varchar) calcMounth
	,'base' averageMethod
	,'1' typePrepayment
	,cast(Vpl_DayAvn as varchar) prepaymentDay
	,cast((select max(VoSF_Rcd) from VoSFEK where VoSFEK.Vo_Cd = PAYVO1.vo_cd and VoSFEK.Vo_cfg = 0) as varchar) dictFundSourceID
/*
	,roundAverage
	,dictTimeCostID
	,estimated
	,valuation
	,currencyID
	,isPublicSalary
	,hourType
	,typeDateCalc
	,typePeriodRst
	,typeRateFind
	,alimonyLessPayment
	,percPrepayment
	,dictFundSourceID
*/
from PAYVO1
inner join PSPR on SprSpr_Cd = 787202 and payvo1.Vo_Cd = pspr.spr_cd
inner join /*SYS_SCHEMA*/i711_sys.dbo.sspr on sspr.sprspr_cd = 131842 and sspr.spr_cdlng = 2 and sspr.spr_cd = payvo1.vo_met
where
vo_cd in (
	select distinct KpuPrkz_SysOp
	from kpuprk1
	union
	select distinct pdnch_cd
	from pdnch
	where pdnch_datk <= '1876-12-31' or pdnch_datk >= @dateFrom
	union
	select distinct pdudr_cd
	from pdudr
	where pdudr_datk <= '1876-12-31' or pdudr_datk >= @dateFrom
	union
	select distinct kpunch_cd
	from kpunch1
	where kpunch_datk <= '1876-12-31' or kpunch_datk >= @dateFrom
	union
	select distinct kpuudr_cd
	from kpuudr1
	where kpuudr_datk <= '1876-12-31' or kpuudr_datk >= @dateFrom
	union
	select distinct kpurl_cdvo
	from kpurlo1
	where kpurl_cdvo <> 0
	and kpurl_datup >= @dateFrom
)
