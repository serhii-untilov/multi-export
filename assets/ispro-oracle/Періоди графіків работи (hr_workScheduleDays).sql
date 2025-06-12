-- Періоди графіків работи (hr_workScheduleDays)
select
	Per_Id "ID"
	,p1.Grf_Cd "workScheduleID"

	--,cast(row_number() over(partition BY p1.grf_cd ORDER BY p1.grf_cd, per_id) as varchar) numDay
	,TO_CHAR(ROW_NUMBER() OVER (PARTITION BY p1.grf_cd ORDER BY p1.grf_cd, per_id)) AS "numDay"

	,case when Per_Hrs = 0 then '2' else '1' end "dictTimeCostID"

	-- ,Per_Hrs "hoursWork"
	,TO_CHAR(Per_Hrs, 'FM9990.99', 'NLS_NUMERIC_CHARACTERS = ''.,''') "hoursWork"

	,'0' "hoursWorkNight"
	,'0' "hoursWorkEvening"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.GrfPerB p1
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.paygrf g1 on g1.grf_cd = p1.grf_cd
where g1.grf_del = 0 or exists (
	select null
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 p1
	where p1.KpuPrkz_RejWr = g1.grf_cd
)
