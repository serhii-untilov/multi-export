-- ���� ������ (hr_employeeExperience)
declare @dateTo date = GETDATE()
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @sprpdr_cd nvarchar(20) = /*SPRPDR_CD*/
declare @employeeDateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 0) * 10000 + 101 as varchar(10)) as date)))
/*BEGIN-OF-HEAD*/
select 'ID' ID, 'employeeID' employeeID, 'dictExperienceID' dictExperienceID, 'calcDate' calcDate, 'startCalcDate' startCalcDate, 'comment' comment, 'impEmployeeID' impEmployeeID, 'importInfo' importInfo
,'employeeNumberID' employeeNumberID
union all
/*END-OF-HEAD*/
select
	cast(ROW_NUMBER() OVER(ORDER BY employeeID, dictExperienceID ASC) as varchar) AS ID
	,cast(employeeID as varchar) employeeID
	,cast(dictExperienceID as varchar) dictExperienceID
	,cast(cast(calcDate as date) as varchar) calcDate
	,'' startCalcDate
	,'' comment
	,'' impEmployeeID
	,'' importInfo
	,case when employeeNumberID is null then '' else cast(employeeNumberID as varchar) end employeeNumberID
from (
	-- 1 ��������� ����
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,1 dictExperienceID
		,Kpu_DtObSt calcDate --min(Kpu_DtObSt) calcDate
		,null employeeNumberID
	from kpuc1 c1
	inner join KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd

	inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
		select max(pdr2.bookmark)
		from kpuprk1 pdr2
		where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
			select max(pdr3.kpuprkz_dtv)
			from kpuprk1 pdr3
			where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
		)
	) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

	where x1.kpu_tnosn = 0 and Kpu_DtObSt > '1876-12-31' and c1.Kpu_Rcd < 4000000000
		and (c1.Kpu_Flg & 2) = 0	-- ����� � ��������
		and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
		and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)
	--group by CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END
	-- 2 ������������ ����
	union all
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,2 dictExperienceID
		,Kpu_DtNpSt calcDate -- min(Kpu_DtNpSt) calcDate
		,null employeeNumberID
	from kpuc1 c1
	inner join KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd

	inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
		select max(pdr2.bookmark)
		from kpuprk1 pdr2
		where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
			select max(pdr3.kpuprkz_dtv)
			from kpuprk1 pdr3
			where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
		)
	) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

	where x1.kpu_tnosn = 0 and Kpu_DtNpSt > '1876-12-31' and c1.Kpu_Rcd < 4000000000
		and (c1.Kpu_Flg & 2) = 0	-- ����� � ��������
		and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
		and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)
	--group by CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END
	-- 3 ���� �� ���������
	union all
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,3 dictExperienceID
		,Kpu_DtOrgSt calcDate --min(Kpu_DtOrgSt) calcDate
		,null employeeNumberID
	from kpuc1 c1
	inner join KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd

	inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
		select max(pdr2.bookmark)
		from kpuprk1 pdr2
		where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
			select max(pdr3.kpuprkz_dtv)
			from kpuprk1 pdr3
			where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
		)
	) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

	where x1.kpu_tnosn = 0 and Kpu_DtOrgSt > '1876-12-31' and c1.Kpu_Rcd < 4000000000
		and (c1.Kpu_Flg & 2) = 0	-- ����� � ��������
		and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
		and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)
	--group by CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END
	-- 4 ��������� ����
	union all
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,4 dictExperienceID
		,Kpu_DtSrSt calcDate --min(Kpu_DtSrSt) calcDate
		,null employeeNumberID
	from kpuc1 c1
	inner join KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd

	inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
		select max(pdr2.bookmark)
		from kpuprk1 pdr2
		where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
			select max(pdr3.kpuprkz_dtv)
			from kpuprk1 pdr3
			where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
		)
	) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

	where x1.kpu_tnosn = 0 and Kpu_DtSrSt > '1876-12-31' and c1.Kpu_Rcd < 4000000000
		and (c1.Kpu_Flg & 2) = 0	-- ����� � ��������
		and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
		and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)
	--group by CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END
	-- 5 ��������� ����
	union all
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,5 dictExperienceID
		,Kpu_DtOtrSt calcDate --min(Kpu_DtOtrSt) calcDate
		,null employeeNumberID
	from kpuc1 c1
	inner join KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd

	inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
		select max(pdr2.bookmark)
		from kpuprk1 pdr2
		where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
			select max(pdr3.kpuprkz_dtv)
			from kpuprk1 pdr3
			where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
		)
	) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

	where x1.kpu_tnosn = 0 and Kpu_DtOtrSt > '1876-12-31' and c1.Kpu_Rcd < 4000000000
		and (c1.Kpu_Flg & 2) = 0	-- ����� � ��������
		and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
		and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)
	--group by CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END
	-- 6 ���� �������������
	union all
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,6 dictExperienceID
		,Kpu_DtGS calcDate --min(Kpu_DtGS) calcDate
		,null employeeNumberID
	from kpuc1 c1
	inner join KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd

	inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
		select max(pdr2.bookmark)
		from kpuprk1 pdr2
		where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
			select max(pdr3.kpuprkz_dtv)
			from kpuprk1 pdr3
			where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
		)
	) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

	where x1.kpu_tnosn = 0 and Kpu_DtGS > '1876-12-31' and c1.Kpu_Rcd < 4000000000
		and (c1.Kpu_Flg & 2) = 0	-- ����� � ��������
		and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
		and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)
	--group by CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END
	-- 7 ������������ ���� �������������
	union all
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,7 dictExperienceID
		,Kpu_DtGSNp calcDate --min(Kpu_DtGSNp) calcDate
		,null employeeNumberID
	from kpuc1 c1
	inner join KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd

	inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
		select max(pdr2.bookmark)
		from kpuprk1 pdr2
		where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
			select max(pdr3.kpuprkz_dtv)
			from kpuprk1 pdr3
			where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
		)
	) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

	where x1.kpu_tnosn = 0 and Kpu_DtGSNp > '1876-12-31' and c1.Kpu_Rcd < 4000000000
		and (c1.Kpu_Flg & 2) = 0	-- ����� � ��������
		and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
		and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)
	--group by CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END
	-- �������� ����
	union all
	select
		case when x1.Kpu_TnOsn = 0 then x1.Kpu_Rcd else x2.kpu_Rcd end employeeID --CASE WHEN ISNUMERIC(c1.kpu_cdnlp) = 1 THEN CAST(c1.kpu_cdnlp AS numeric) ELSE s1.kpu_rcd END employeeID
		,kpustg_cd + 10 dictExperienceID
		,dateadd(day, -sum(datediff(day, cast(KpuAStg_DtN as date),
			case when kpuastg_dtk <= '1876-12-31' then cast(@dateTo as date) else cast(KpuAStg_DtK as date) end)), cast(@dateTo as date))
			calcDate
		,x1.kpu_rcd employeeNumberID
	from KpuAdStgDat1 s1
	inner join KPUC1 c1 on c1.Kpu_Rcd = s1.kpu_rcd
	inner join KPUX x1 on x1.Kpu_Rcd = s1.kpu_rcd

	inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
		select max(pdr2.bookmark)
		from kpuprk1 pdr2
		where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
			select max(pdr3.kpuprkz_dtv)
			from kpuprk1 pdr3
			where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
		)
	) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

	left join kpux x2 on x2.kpu_tn = x1.kpu_tnosn
	where c1.Kpu_Rcd < 4000000000
		and (c1.Kpu_Flg & 2) = 0	-- ����� � ��������
		and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
		and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)
--	and (x1.Kpu_TnOsn = 0 or not exists (
--		select null
--		from kpuadstgdat1 s2
--		where s2.kpu_rcd = x2.kpu_rcd
--		and s2.kpustg_cd = s1.kpustg_cd
--	))
	group by
		case when x1.Kpu_TnOsn = 0 then x1.Kpu_Rcd else x2.kpu_Rcd end
		,x1.kpu_rcd
		,kpustg_cd + 10
) t1
inner join (
	-- ����������� ������������ �� ���
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
			and (Kpu_Flg & 2) = 0	-- ����� � ��������
			and x1.kpu_tnosn = 0
			and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
			and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)
	) t1
	group by kpu_cdnlp
) t2 on t2.kpu_rcd = t1.employeeID