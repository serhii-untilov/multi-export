-- ����������� ���������� (hr_employeePosition)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
declare @minDateRaiseSalary date = '2016-01-01'; -- ���� ̳����������� �� 14.06.2016 �. � 263/10/136-16
/*BEGIN-OF-HEAD*/
select 'ID' ID
	,'employeeID' employeeID
	,'taxCode' taxCode
	,'tabNum' tabNum
	,'employeeNumberID' employeeNumberID
	,'departmentID' departmentID, 'positionID' positionID, 'dateFrom' dateFrom
	,'dateTo' dateTo, 'changeDateTo' changeDateTo, 'workScheduleID' workScheduleID, 'workerType' workerType, 'mtCount' mtCount, 'description' description
	,'dictRankID' dictRankID, 'dictStaffCatID' dictStaffCatID, 'payElID' payElID, 'accrualSum' accrualSum, 'raiseSalary' raiseSalary, 'isIndex' isIndex
	,'isActive' isActive, 'workPlace' workPlace, 'dictFundSourceID' dictFundSourceID, 'dictCategoryECBID' dictCategoryECBID, 'accountID' accountID
	,'dictPositionID' dictPositionID
	,'orderID' orderID
	,'orderNumber' orderNumber
	,'orderDate' orderDate
	,'staffingTableID' staffingTableID
union all
/*END-OF-HEAD*/
select ID
	,cast(t2.kpu_rcd as varchar) employeeID
	,taxCode
	,tabNum
	,employeeNumberID
	,departmentID, positionID, dateFrom
	,dateTo, changeDateTo, workScheduleID, workerType, mtCount, description
	,dictRankID, dictStaffCatID, payElID, accrualSum, raiseSalary, isIndex
	,isActive, workPlace, dictFundSourceID, dictCategoryECBID, accountID
	,dictPositionID
	,orderID
	,orderNumber
	,orderDate
	,staffingTableID
from (	
	select
		cast(p1.bookmark as varchar) ID	
		,cast(p1.kpu_rcd as varchar) employeeID	
		,case when len(c1.kpu_cdnlp) <> 0 then c1.kpu_cdnlp
			when len(psp.KpuPsp_Ser) <> 0 or len(psp.KpuPsp_Nmr) <> 0 then psp.KpuPsp_Ser + ' ' + psp.KpuPsp_Nmr
			else	'*' +
					left(dbo.fnKdrSegregateFio(c1.kpu_fio, 1), 1) +
					left(dbo.fnKdrSegregateFio(c1.kpu_fio, 2), 1) +
					left(dbo.fnKdrSegregateFio(c1.kpu_fio, 3), 1) +
					cast(day(c1.kpu_dtroj) as varchar) +
					cast(month(c1.kpu_dtroj) as varchar) +
					cast((year(c1.kpu_dtroj) % 100) as varchar)
			 end taxCode	
		,cast(x1.kpu_tn as varchar) tabNum	 
		,cast(p1.kpu_rcd as varchar) employeeNumberID	
		,cast(p1.KpuPrkz_PdRcd as varchar) departmentID	
		--,cast(p1.kpuprkz_dol as varchar) positionID	
		,cast(case when sprdol.sprd_cd is null then null else p1.kpuprkz_pdrcd * 10000 + p1.kpuprkz_dol end as varchar) positionID
		,cast(cast(case when p1.kpuprkz_dtv <= '1876-12-31' then c1.kpu_dtpst else p1.kpuprkz_dtv end as date) as varchar) dateFrom	
		,cast(cast(case when p2.kpuprkz_dtv is null OR p2.kpuprkz_dtv <= '1876-12-31' then '9999-12-31' else p2.kpuprkz_dtv - 1 end as date) as varchar) dateTo	
		,cast(cast(case when p1.KpuPrkz_DtNzE <= '1876-12-31' then null else p1.KpuPrkz_DtNzE end as date) as varchar) changeDateTo	
		,cast(p1.KpuPrkz_RejWr as varchar) workScheduleID
		,cast(case when ASCII(spst.SPR_NMSHORT) = 7 then 2 -- ���������
			  when ASCII(spst.SPR_NMSHORT) = 4 then 4 -- ��������
			  else 1 -- �������
			  end as varchar) workerType	
		,cast(p1.KpuPrkz_QtStv as varchar) mtCount	
		,cast(x1.kpu_tn as varchar) + ' ' + c1.kpu_fio + ' ' + coalesce(sprdol.sprd_nmim, '') description	
		,'0' dictRankID -- ,p1.KpuPrkz_Rn dictRankID -- � �������� ���� ������������ �� �� ����������. � ������������ � ������� ������������������
		,cast(p1.KpuPrkz_Kat as varchar) dictStaffCatID
		,cast(p1.KpuPrkz_SysOp as varchar) payElID
		,cast(cast(( { fn CONVERT( p1.KpuPrkz_Okl, SQL_DOUBLE ) } / { fn POWER( 10, p1.KpuPrkz_KfcMT ) } ) as numeric(19,2)) as varchar) accrualSum
		,cast(cast(
				case 
				WHEN p1.KpuPrkz_IdxBsd <= '1876-12-31' and { fn MOD( { fn TRUNCATE( p1.KpuPrkz_Prz / 2, 0 ) }, 2 ) } <> 0 and p1.kpuprkz_dtv >= @minDateRaiseSalary then p1.kpuprkz_dtv
				when dateRaiseSalary.kpuprkz_dtv is not null then p1.kpuprkz_dtv
				when p1.KpuPrkz_IdxBsd <= '1876-12-31' and lastIdxBase.kpuprkz_dtv is not null and lastIdxBase.kpuprkz_dtv >= @minDateRaiseSalary then lastIdxBase.kpuprkz_dtv
				when p1.KpuPrkz_IdxBsd <= '1876-12-31' and idxBase.kpuprkz_dtv is not null and idxBase.kpuprkz_dtv >= @minDateRaiseSalary then idxBase.kpuprkz_dtv			
				when p1.KpuPrkz_IdxBsd < c1.kpu_dtpst and c1.kpu_dtpst >= @minDateRaiseSalary then c1.kpu_dtpst
				when p1.KpuPrkz_IdxBsd <= '1876-12-31' then null
				else p1.KpuPrkz_IdxBsd end
			as date) as varchar) raiseSalary
		,cast(CASE WHEN { fn MOD( { fn TRUNCATE( p1.KpuPrkz_Prz / 1, 0 ) }, 2 ) } <> 0 then 1 else 0 end as varchar) isIndex
		,'1' isActive	
		,cast(case when x1.kpu_tnosn <> 0 then 2 -- ���������� ��������
			  when ASCII(spst.SPR_NMSHORT) in (2, 6) then 3 -- ���������� ��������
			  when ASCII(spst.SPR_NMSHORT) = 3 then 4 -- ���� ������
			  else 1 -- �������
			  end as varchar) workPlace	
		,cast(case when p1.KpuPrkz_SF = 0 then null else p1.KpuPrkz_SF end as varchar) dictFundSourceID	
		,cast(case when p1.KpuPrkz_Rn <> 0 then 3 -- ��� ���������
			when p1.KpuPrkz_CdSZ = 0 then 1 else p1.KpuPrkz_CdSZ end as varchar) dictCategoryECBID	
		,cast(p1.KpuPrkz_Sch as varchar) accountID	
		,cast(p1.kpuprkz_dol as varchar) dictPositionID
		,cast(p1.kpuprkz_rcd as varchar) orderID
		,p1.kpuprkz_cd orderNumber
		,cast(cast(case when p1.kpuprkz_dt <= '1876-12-31' then '' else p1.kpuprkz_dt end as date) as varchar) orderDate
		,cast(p1.KpuPrkz_RcS as varchar) staffingTableID
	from kpuprk1 p1
	inner join KPUX x1 on x1.Kpu_Rcd = p1.Kpu_Rcd
	inner join KPUC1 c1 on c1.Kpu_Rcd = p1.kpu_rcd
	left join (
		select kpu_rcd, max(kpuprkz_dtv) kpuprkz_dtv
		from kpuprk1
		where kpuprkz_dtv < @dateFrom
		group by kpu_rcd
	) minDatePrk on minDatePrk.kpu_rcd = p1.kpu_rcd
	left join sprdol on sprd_cd = p1.kpuprkz_dol
	left join pspr spst on spst.sprspr_cd = 547 and spst.spr_cd = p1.kpuprkz_spst -- ASCII( SPR_NMSHORT ) 
	left join KPUPRK1 p2 on p2.Kpu_Rcd = p1.Kpu_Rcd and p2.bookmark =
	(
		SELECT min(p3.bookmark)
		from KPUPRK1 p3 
		where p3.Kpu_Rcd = p1.kpu_rcd
		and p3.kpuprkz_dtv =
		(
			SELECT MIN(p4.kpuprkz_dtv)
			from KPUPRK1 p4
			where p4.Kpu_Rcd = p1.Kpu_Rcd
			and p4.KpuPrkz_DtV > p1.kpuprkz_dtv
		)
	)
	left join KPUPRK1 idxBase on idxBase.Kpu_Rcd = p1.Kpu_Rcd and idxBase.bookmark =
	(
		SELECT MAX(p3.bookmark)
		from KPUPRK1 p3 
		where p3.Kpu_Rcd = p1.kpu_rcd
		and p3.kpuprkz_dtv =
		(
			SELECT MAX(p4.kpuprkz_dtv)
			from KPUPRK1 p4
			where p4.Kpu_Rcd = p1.Kpu_Rcd
			and { fn MOD( { fn TRUNCATE( p1.KpuPrkz_Prz / 2, 0 ) }, 2 ) } <> 0
			and p4.KpuPrkz_DtV < p1.kpuprkz_dtv
		)
	)
	left join KPUPRK1 lastIdxBase on lastIdxBase.Kpu_Rcd = p1.Kpu_Rcd and lastIdxBase.bookmark =
	(
		SELECT MAX(p3.bookmark)
		from KPUPRK1 p3 
		where p3.Kpu_Rcd = p1.kpu_rcd
		and p3.kpuprkz_dtv =
		(
			SELECT MAX(p4.kpuprkz_dtv)
			from KPUPRK1 p4
			where p4.Kpu_Rcd = p1.Kpu_Rcd
			and KpuPrkz_IdxBsd > '1876-12-31'
			and p4.KpuPrkz_DtV < p1.kpuprkz_dtv
		)
	)
	left join KPUPRK1 dateRaiseSalary on dateRaiseSalary.Kpu_Rcd = p1.Kpu_Rcd and dateRaiseSalary.bookmark =
	(
		SELECT max(p3.bookmark)
		from KPUPRK1 p3 
		where p3.Kpu_Rcd = p1.kpu_rcd
		and p3.kpuprkz_dtv =
		(
			SELECT Max(p4.kpuprkz_dtv)
			from KPUPRK1 p4
			where p4.Kpu_Rcd = p1.Kpu_Rcd
			and p4.KpuPrkz_DtV < p1.kpuprkz_dtv
			and cast(( { fn CONVERT( p1.KpuPrkz_Okl, SQL_DOUBLE ) } / { fn POWER( 10, p1.KpuPrkz_KfcMT ) } ) as numeric(19,2)) >
				cast(( { fn CONVERT( p4.KpuPrkz_Okl, SQL_DOUBLE ) } / { fn POWER( 10, p4.KpuPrkz_KfcMT ) } ) as numeric(19,2))
		)
	)
	left join kpupsp1 psp on psp.kpu_rcd = x1.kpu_rcd and KpuPsp_Add = 0
	where 
	(	p1.KpuPrkz_DtV >= c1.kpu_dtpst or not exists
		(
			SELECT null
			from KPUPRK1 p5
			where p5.Kpu_Rcd = p5.Kpu_Rcd
			and p5.KpuPrkz_DtV = c1.kpu_dtpst
		)
	)
	and (c1.kpu_flg & 2) = 0
	and (p1.kpuprkz_dtv >= @dateFrom 
			or p1.kpuprkz_dtv <= c1.kpu_dtpst
			or (minDatePrk.kpuprkz_dtv is not null 
				and p1.kpuprkz_dtv = minDatePrk.kpuprkz_dtv))
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
	) t1
	group by kpu_cdnlp
) t2 on t2.kpu_cdnlp = t1.taxCode
