-- ������� ����������� ���������� (hr_employeeAccrual)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @sprpdr_cd nvarchar(20) = /*SPRPDR_CD*/
/*BEGIN-OF-HEAD*/
select 
	'ID' ID
	,'employeeID' employeeID
	,'tabNum' tabNum
	,'employeeNumberID' employeeNumberID
	,'payElID' payElID
	,'dateFrom' dateFrom
	,'dateTo' dateTo
	,'accrualSum' accrualSum
	,'accrualRate' accrualRate
	,'orderNumber' orderNumber
	,'orderDatefrom' orderDatefrom
	,'taxCode' taxCode
union all
/*END-OF-HEAD*/
select 
	ID
	,cast(t4.kpu_rcd as varchar) employeeID	
	,tabNum
	,employeeNumberID
	,payElID
	,dateFrom
	,dateTo
	,accrualSum
	,accrualRate
	,orderNumber
	,orderDatefrom
	,taxCode
from (
	select 
		ID
		,tabNum
		,employeeNumberID
		,payElID
		,dateFrom
		,dateTo
		,accrualSum
		,accrualRate
		,orderNumber
		,orderDatefrom
		,case when len(c2.kpu_cdnlp) <> 0 then c2.kpu_cdnlp
			when len(p2.KpuPsp_Ser) <> 0 or len(p2.KpuPsp_Nmr) <> 0 then p2.KpuPsp_Ser + ' ' + p2.KpuPsp_Nmr
			else	'*' +
					left(dbo.fnKdrSegregateFio(c2.kpu_fio, 1), 1) +
					left(dbo.fnKdrSegregateFio(c2.kpu_fio, 2), 1) +
					left(dbo.fnKdrSegregateFio(c2.kpu_fio, 3), 1) +
					cast(day(c2.kpu_dtroj) as varchar) +
					cast(month(c2.kpu_dtroj) as varchar) +
					cast((year(c2.kpu_dtroj) % 100) as varchar)
			 end taxCode
	from (
		select 
			cast(n1.KpuNch_Id as varchar) ID	
			,cast(x1.kpu_tn as varchar) tabNum
			,cast(n1.kpu_rcd as varchar) employeeNumberID		
			,cast(n1.kpunch_cd as varchar) payElID	
			,cast(case when n1.kpuNch_datn <= '1876-12-31' then null else CAST(n1.kpuNch_datn as DATE) end as varchar) dateFrom	
			,cast(case when n1.kpuNch_datk <= '1876-12-31' then '9999-12-31' else CAST(n1.kpuNch_datk as DATE) end as varchar) dateTo	
			,cast(case 
					when vo_grp = 1 then { fn CONVERT( n1.KpuNch_Sm, SQL_DOUBLE ) } / { fn POWER( 10, n1.KpuNch_MT ) }
					when (KpuNch_Prz & 1) <> 0 then null 
					else { fn CONVERT( n1.KpuNch_Sm, SQL_DOUBLE ) } / { fn POWER( 10, n1.KpuNch_MT ) } 
					end as varchar) accrualSum	
			,cast(case 
					when vo_grp = 1 then null
					when (KpuNch_Prz & 1) = 0 then null 
					else { fn CONVERT( n1.KpuNch_Sm, SQL_DOUBLE ) } / { fn POWER( 10, n1.KpuNch_MT ) } 
					end as varchar) accrualRate	
			,n1.KpuNch_CdPr orderNumber	
			,cast(case when n1.KpuNch_DtPr <= '1876-12-31' then null else cast(n1.KpuNch_DtPr as DATE) end as varchar) orderDatefrom 
			,coalesce(x2.kpu_rcd, x1.kpu_rcd) kpu_rcdOsn
		from kpunch1 n1
		inner join payvo1 v1 on v1.vo_cd = n1.kpunch_cd
		inner join kpuc1 c1 on c1.kpu_rcd = n1.kpu_rcd
		inner join kpux x1 on x1.kpu_rcd = n1.kpu_rcd

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
		where (c1.Kpu_Flg & 2) = 0	-- ����� � ��������
			and (kpunch_datk <= '1876-12-31' or kpunch_datk >= @dateFrom)
			and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
	) t1	
	inner join kpuc1 c2 on c2.kpu_rcd = t1.kpu_rcdOsn
	left join kpupsp1 p2 on p2.kpu_rcd = t1.kpu_rcdOsn and KpuPsp_Add = 0
) t2 	
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
	) t3
	group by kpu_cdnlp
) t4 on t4.kpu_cdnlp = t2.taxCode