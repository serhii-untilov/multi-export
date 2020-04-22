-- Скорочення робочого дня-тижня - працівники (hr_timeSheetChangeEmp)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
/*BEGIN-OF-HEAD*/
select
	'ID' ID
	,'timeSheetChangeID' timeSheetChangeID
	,'employeeNumberID' employeeNumberID
union all	
/*END-OF-HEAD*/
select
	cast(bookmark as varchar) ID	
	,cast(bookmark as varchar) timeSheetChangeID	
	,cast(kpu_rcd as varchar) employeeNumberID
from KpuIgrB
where kpuigr_datEnd <= '1876-12-31' or kpuigr_datEnd >= @dateFrom
