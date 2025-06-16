-- Графіки роботи (hr_workSchedule)
select
	grf_cd "ID",
	grf_cd "code",
	case
		when grf_cd = 0
		and length (grf_nm) = 0 then '40 годин на тиждень'
		when length (grf_nm) = 0 then 'Графік роботи без назви'
		else Grf_Nm
	end "name",
	TO_CHAR (Grf_DtBs, 'YYYY-MM-DD') "dateFrom",
	'9999-12-31' "dateTo",
	'01' "dictStandartTimeCode",
	'FROM_SCHEDULE' "begins",
	'null' "organizationID",
	case
		when BITAND (grf_msk, 1) <> 0 then 1
		else 0
	end "isPayDayOff",
	case
		when BITAND (grf_msk, 8) <> 0 then 1
		else 0
	end "isPayHoliday",
	'0' "isCalendar" -- ???
,
	case
		when grf_hol = 2 then 1
		else 0
	end "isHoliday",
	case
		when grf_phol = 3 then 1
		else 0
	end "isLastHoliday"
	-- ,cast(case when (grf_msk & 0x200000) <> 0 then 1 else 0 end as varchar) isChangeDay
,
	case
		when BITAND (grf_msk, TO_NUMBER ('200000', 'XXXXXX')) <> 0 then 1
		else 0
	end "isChangeDay"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.PAYGRF g1
where grf_del = 0
	or exists (
		select
			null
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 p1
		where p1.KpuPrkz_RejWr = g1.grf_cd
	)
