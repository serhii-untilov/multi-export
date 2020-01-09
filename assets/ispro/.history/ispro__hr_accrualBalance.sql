-- Сальдо по місяцям (hr_accrualBalance)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
declare @currentPeriod date = (
	select CASE WHEN LEN (RTRIM(CrtParm_Val)) = 8 THEN CONVERT(DATE, CrtParm_Val, 3) ELSE	CONVERT(DATE, CrtParm_Val, 103) END
	from vwCrtParm 
	where crtParm_cdBpr = 2
	and crtParm_id = 'Period_DatOpen'
)
/*
select 
	'ID' ID
	,'employeeNumberID' employeeNumberID
	,'periodCalc' periodCalc
	,'dictFundSourceID' dictFundSourceID
	,'sumFrom' sumFrom
	,'sumPlus' sumPlus
	,'sumMinus' sumMinus
	,'sumPay' sumPay
	,'sumTo' sumTo
union all
*/
select 
	cast(s1.bookmark as varchar) ID	
	,cast(x1.kpu_rcd as varchar) employeeNumberID	
	,cast(cast(s1.kpurl_datUp as date) as varchar) periodCalc	
	,cast(case when s1.kpurl_sf = 0 then null else s1.kpurl_sf end as varchar) dictFundSourceID	
	,cast(CONVERT(DECIMAL(19, 0), s1.kpurl_sin) / 100 as varchar) sumFrom	
	,cast(CONVERT(DECIMAL(19, 0), s1.kpurl_nch) / 100 as varchar) sumPlus	
	,cast(CONVERT(DECIMAL(19, 0), s1.kpurl_udr - t1.kpurl_sm) / 100 as varchar) sumMinus
	,cast(CONVERT(DECIMAL(19, 0), t1.kpurl_sm) / 100 as varchar) sumPay	
	,cast(CONVERT(DECIMAL(19, 0), s1.kpurl_sout) / 100 as varchar) sumTo
from kpurlonus s1
inner join kpux x1 on x1.kpu_tn = s1.kpu_tn
inner join (
	select r1.kpu_tn
		,r1.kpurl_datup
		,0 kpurl_sf
		,sum(r1.kpurl_sm) kpurl_sm
	from kpurlo1 r1
	inner join payvo1 v1 on v1.vo_cd = r1.kpurl_cdvo
	where r1.KpuRl_CdVo <> 0
		and r1.KpuRl_DatUp >= @dateFrom
		and (r1.KpuRl_Prz & 65536) = 0 -- Записи внутреннего совместителя - пропускаем
		and (r1.KpuRl_DatUp < @currentPeriod or {fn MOD({fn TRUNCATE(KpuRl_Prz / 1, 0)}, 2)} = 0)
		and v1.vo_grp = 130 -- Виплати
	group by r1.kpu_tn, r1.kpurl_datup
	union all
	select r1.kpu_tn
		,r1.kpurl_datup
		,r1.kpurl_sf
		,sum(r1.kpurl_sm) kpurl_sm
	from kpurlo1 r1
	inner join payvo1 v1 on v1.vo_cd = r1.kpurl_cdvo
	where r1.KpuRl_CdVo <> 0
		and r1.kpurl_sf <> 0
		and r1.KpuRl_DatUp >= @dateFrom
		and (r1.KpuRl_Prz & 65536) = 0 -- Записи внутреннего совместителя - пропускаем
		and (r1.KpuRl_DatUp < @currentPeriod or {fn MOD({fn TRUNCATE(KpuRl_Prz / 1, 0)}, 2)} = 0)
		and v1.vo_grp = 130 -- Виплати
	group by r1.kpu_tn, r1.kpurl_datup, r1.kpurl_sf
) t1 on t1.kpu_tn = s1.kpu_tn and t1.kpurl_datup = s1.kpurl_datup and t1.kpurl_sf = s1.kpurl_sf
where s1.kpurl_datup between @dateFrom and dateAdd(day, -1, @currentPeriod)
