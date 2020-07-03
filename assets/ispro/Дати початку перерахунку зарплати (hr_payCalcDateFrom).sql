-- Дати початку перерахунку зарплати (hr_payCalcDateFrom)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
declare @currentPeriod date = (
	select CASE WHEN LEN (RTRIM(CrtParm_Val)) = 8 THEN CONVERT(DATE, CrtParm_Val, 3) ELSE	CONVERT(DATE, CrtParm_Val, 103) END
	from vwCrtParm 
	where crtParm_cdBpr = 2
	and crtParm_id = 'Period_DatOpen'
	and (@sysste_rcd is null or CrtFrm_Rcd = @sysste_rcd)
)
/*BEGIN-OF-HEAD*/
select
	'ID' ID
	,'employeeNumberID' employeeNumberID
	,'tabNum'
	,'periodCalc' periodCalc
	,'periodSalary' periodSalary
union all	
/*END-OF-HEAD*/
select 
	cast(kpu_rcd as varchar) ID	
	,cast(kpu_rcd as varchar) employeeNumberID	
	,cast(kpu_tn as varchar) tabNum
	,cast(cast(@currentPeriod as date) as varchar) periodCalc	
	,cast(cast(kpu_datreclc as date) as varchar) periodSalary	
from kpux
where kpu_datreclc > '1876-12-31'	
and kpu_datreclc < @currentPeriod
--union all
--select 
--	cast(x1.kpu_rcd as varchar) ID	
--	,cast(x1.kpu_rcd as varchar) employeeNumberID	
--	,cast(kpu_tn as varchar) tabNum
--	,cast(cast(KpuArcDat_Per as date) as varchar) periodCalc	
--	,cast(cast(KpuArcDat_Dat as date) as varchar) periodSalary	
--from KpuArDtRClc1 a1
--inner join kpux x1 on x1.kpu_rcd = a1.kpu_rcd
--where KpuArcDat_Per >= @dateFrom