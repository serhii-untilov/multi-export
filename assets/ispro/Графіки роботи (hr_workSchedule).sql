-- Графіки роботи (hr_workSchedule)
/*BEGIN-OF-HEAD*/
select 'ID' ID, 'code' code, 'name' name, 'dateFrom' dateFrom, 'dateTo' dateTo, 'dictStandartTimeID' dictStandartTimeID, 'begins' begins,
	'organizationID' organizationID, 'isPayDayOff' isPayDayOff, 'isPayHoliday' isPayHoliday, 'isCalendar' isCalendar, 'isHoliday' isHoliday,
	'isLastHoliday' isLastHoliday, 'isChangeDay' isChangeDay
union all	
/*END-OF-HEAD*/
select 
	cast(grf_cd as varchar) ID
	,cast(grf_cd as varchar) code
	,case when grf_cd = 0 and len(grf_nm) = 0 then '40 годин на тиждень' 
		when len(grf_nm) = 0 then 'Графік роботи без назви' 
		else Grf_Nm end name
	,cast(cast(Grf_DtBs as date) as varchar) dateFrom
	,'9999-12-31' dateTo
	,'01' dictStandartTimeCode
	,'FROM_SCHEDULE' begins
	,null organizationID
	,cast(case when (grf_msk & 1) <> 0 then 1 else 0 end as varchar) isPayDayOff
	,cast(case when (grf_msk & 8) <> 0 then 1 else 0 end as varchar) isPayHoliday
	,'0' isCalendar -- ???
	,cast(case when grf_hol = 2 then 1 else 0 end as varchar) isHoliday
	,cast(case when grf_phol = 3 then 1 else 0 end as varchar) isLastHoliday
	,cast(case when (grf_msk & 0x200000) <> 0 then 1 else 0 end as varchar) isChangeDay
from PAYGRF g1
where grf_del = 0 or exists (
	select null
	from kpuprk1 p1
	where p1.KpuPrkz_RejWr = g1.grf_cd
);