-- Розрахункові періоди (hr_dictPeriod)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
declare @currentPeriod date = (
	select CASE WHEN LEN (RTRIM(CrtParm_Val)) = 8 THEN CONVERT(DATE, CrtParm_Val, 3) ELSE	CONVERT(DATE, CrtParm_Val, 103) END
	from vwCrtParm 
	where crtParm_cdBpr = 2
	and crtParm_id = 'Period_DatOpen'
)
select 
	'ID' ID
	,'dateFrom' dateFrom
	,'dateTo' dateTo
	,'isClosed' isClosed
	,'isCurrent' isCurrent
union all
select 
	cast(bookmark as varchar) ID	
	,cast(cast(PerBas_Period as date) as varchar) dateFrom
	,cast(cast(DATEADD(DAY, -1, DATEADD(MONTH, 1, cast(perBas_period as date))) as date) as varchar) dateTo
	,'1' isClosed
	,'0' isCurrent	
from PerBas
where perBas_cdBpr = 2
and perBas_period < @currentPeriod
and perBas_period >= @dateFrom
union all
select 
	cast(max(bookmark) + 1 as varchar) ID	
	,cast(cast(@currentPeriod as date) as varchar) dateFrom
	,cast(cast(DATEADD(DAY, -1, DATEADD(MONTH, 1, cast(@currentPeriod as date))) as date) as varchar) dateTo
	,'0' isClosed
	,'1' isCurrent	
	from PerBas
