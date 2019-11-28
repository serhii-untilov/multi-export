-- Период графика работы (hr_workScheduleDays)
select
	'ID' ID
	,'workScheduleID' workScheduleID
	,'numDay' numDay
	,'dictTimeCostID' dictTimeCostID
	,'hoursWork' hoursWork
	,'hoursWorkNight' hoursWorkNight
	,'hoursWorkEvening' hoursWorkEvening
union all
select 
	cast(Per_Id as varchar) ID	
	,cast(p1.Grf_Cd as varchar) workScheduleID	
	,cast(row_number() over(partition BY p1.grf_cd ORDER BY p1.grf_cd, per_id) as varchar) numDay	
	,case when Per_Hrs = 0 then '2' else '1' end dictTimeCostID	
	,cast(Per_Hrs as varchar) hoursWork	
	,'0' hoursWorkNight	
	,'0' hoursWorkEvening
from GrfPerB p1
inner join paygrf g1 on g1.grf_cd = p1.grf_cd
where g1.grf_del = 0 or exists (
	select null
	from kpuprk1 p1
	where p1.KpuPrkz_RejWr = g1.grf_cd
)
