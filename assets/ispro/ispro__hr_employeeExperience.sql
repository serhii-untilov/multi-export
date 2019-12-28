-- Стаж роботи (hr_employeeExperience)
declare @dateTo date = GETDATE()
/*
select 'ID' ID, 'employeeID' employeeID, 'dictExperienceID' dictExperienceID, 'calcDate' calcDate, 'startCalcDate' startCalcDate, 'comment' comment, 'impEmployeeID' impEmployeeID, 'importInfo' importInfo
union all
*/
select 
	cast(ROW_NUMBER() OVER(ORDER BY employeeID, dictExperienceID ASC) as varchar) AS id
	,cast(employeeID as varchar) employeeID
	,cast(dictExperienceID as varchar) dictExperienceID
	,cast(cast(calcDate as date) as varchar) calcDate
	,null startCalcDate
	,null comment
	,null impEmployeeID
	,null importInfo
from (
	-- 1 Загальний стаж
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,1 dictExperienceID
		,Kpu_DtObSt calcDate --min(Kpu_DtObSt) calcDate
	from kpuc1 c1
	inner join KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd
	where x1.kpu_tnosn = 0 and Kpu_DtObSt > '1876-12-31' and c1.Kpu_Rcd < 4000000000
	and (c1.Kpu_Flg & 2) = 0	-- Удалён в зарплате	
	--group by CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END
	-- 2 Безперервний стаж
	union all
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,2 dictExperienceID
		,Kpu_DtNpSt calcDate -- min(Kpu_DtNpSt) calcDate
	from kpuc1 c1
	inner join KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd
	where x1.kpu_tnosn = 0 and Kpu_DtNpSt > '1876-12-31' and c1.Kpu_Rcd < 4000000000
	and (c1.Kpu_Flg & 2) = 0	-- Удалён в зарплате	
	--group by CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END
	-- 3 Стаж на підприємстві
	union all
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,3 dictExperienceID
		,Kpu_DtOrgSt calcDate --min(Kpu_DtOrgSt) calcDate
	from kpuc1 c1
	inner join KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd
	where x1.kpu_tnosn = 0 and Kpu_DtOrgSt > '1876-12-31' and c1.Kpu_Rcd < 4000000000
	and (c1.Kpu_Flg & 2) = 0	-- Удалён в зарплате
	--group by CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END
	-- 4 Страховий стаж
	union all
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,4 dictExperienceID
		,Kpu_DtSrSt calcDate --min(Kpu_DtSrSt) calcDate
	from kpuc1 c1
	inner join KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd
	where x1.kpu_tnosn = 0 and Kpu_DtSrSt > '1876-12-31' and c1.Kpu_Rcd < 4000000000
	and (c1.Kpu_Flg & 2) = 0	-- Удалён в зарплате	
	--group by CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END
	-- 5 Галузевий стаж
	union all
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,5 dictExperienceID
		,Kpu_DtOtrSt calcDate --min(Kpu_DtOtrSt) calcDate
	from kpuc1 c1
	inner join KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd
	where x1.kpu_tnosn = 0 and Kpu_DtOtrSt > '1876-12-31' and c1.Kpu_Rcd < 4000000000
	and (c1.Kpu_Flg & 2) = 0	-- Удалён в зарплате	
	--group by CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END
	-- 6 Стаж держслужбовця
	union all
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,6 dictExperienceID
		,Kpu_DtGS calcDate --min(Kpu_DtGS) calcDate
	from kpuc1 c1
	inner join KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd
	where x1.kpu_tnosn = 0 and Kpu_DtGS > '1876-12-31' and c1.Kpu_Rcd < 4000000000
	and (c1.Kpu_Flg & 2) = 0	-- Удалён в зарплате	
	--group by CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END
	-- 7 Безперервний стаж держслужбовця
	union all
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,7 dictExperienceID
		,Kpu_DtGSNp calcDate --min(Kpu_DtGSNp) calcDate
	from kpuc1 c1
	inner join KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd
	where x1.kpu_tnosn = 0 and Kpu_DtGSNp > '1876-12-31' and c1.Kpu_Rcd < 4000000000
	and (c1.Kpu_Flg & 2) = 0	-- Удалён в зарплате	
	--group by CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END
	-- Додаткові стажі
	union all
	select 
		s1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(c1.kpu_cdnlp) = 1 THEN CAST(c1.kpu_cdnlp AS numeric) ELSE s1.kpu_rcd END employeeID
		,kpustg_cd + 10 dictExperienceID
		,dateadd(day, -sum(datediff(day, cast(KpuAStg_DtN as date), 
			case when kpuastg_dtk = '1876-12-31' then cast(@dateTo as date) else cast(KpuAStg_DtK as date) end)), cast(@dateTo as date)) 
			calcDate
	from KpuAdStgDat1 s1
	inner join KPUC1 c1 on c1.Kpu_Rcd = s1.kpu_rcd
	inner join KPUX x1 on x1.Kpu_Rcd = s1.kpu_rcd
	where Kpu_TnOsn = 0 and c1.Kpu_Rcd < 4000000000
	and (c1.Kpu_Flg & 2) = 0	-- Удалён в зарплате	
	group by
		s1.kpu_rcd --	CASE WHEN ISNUMERIC(c1.kpu_cdnlp) = 1 THEN CAST(c1.kpu_cdnlp AS numeric) ELSE s1.kpu_rcd END
		,kpustg_cd + 10
) t1		
inner join (
	-- Обеспечение уникальности по ИНН
	select max(kpu_rcd) kpu_rcd, kpu_cdnlp
	from (
		select 
			x1.kpu_rcd
			,case when len(c1.kpu_cdnlp) <> 0 then c1.kpu_cdnlp
				when len(p1.KpuPsp_Ser) <> 0 or len(p1.KpuPsp_Nmr) <> 0 then p1.KpuPsp_Ser + ' ' + p1.KpuPsp_Nmr
				else	'*' +
						left(dbo.fnKdrSegregateFio(c1.kpu_fio, 1), 1) +
						left(dbo.fnKdrSegregateFio(c1.kpu_fio, 2), 1) +
						left(dbo.fnKdrSegregateFio(c1.kpu_fio, 3), 1) +
						cast(day(c1.kpu_dtroj) as varchar) +
						cast(month(c1.kpu_dtroj) as varchar) +
						cast((year(c1.kpu_dtroj) % 100) as varchar)
				 end kpu_cdnlp
		from kpux x1
		inner join KPUC1 c1 on c1.Kpu_Rcd = x1.kpu_rcd
		inner join KPUK1 k1 on k1.Kpu_Rcd = x1.kpu_rcd
		left join kpupsp1 p1 on p1.kpu_rcd = x1.kpu_rcd and KpuPsp_Add = 0
		where x1.kpu_tn < 4000000000
			and { fn MOD( { fn TRUNCATE( Kpu_Flg / 64, 0 ) }, 2 ) } = 0
			and (Kpu_Flg & 2) = 0	-- Удалён в зарплате
			and x1.kpu_tnosn = 0
	) t1
	group by kpu_cdnlp
) t2 on t2.kpu_rcd = t1.employeeID