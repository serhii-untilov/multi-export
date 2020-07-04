-- ������ ������� ���������� (hr_employeeNumber)

-- for appointmentDate (���� ����������� �� ������� ������)
--declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
declare @dateTo date = getdate()
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)

/*BEGIN-OF-HEAD*/
select 
	'ID' ID
	,'employeeID' employeeID
	,'taxCode' taxCode
	,'tabNum' tabNum
	,'dateFrom' dateFrom
	,'dateTo' dateTo
	,'description' description
	,'payOutID' payOutID
	,'personalAccount' personalAccount
	,'appointmentDate' appointmentDate -- ���� ����������� �� ������� ������
	,'appointmentOrderDate' appointmentOrderDate
	,'appointmentOrderNumber' appointmentOrderNumber
union all
/*END-OF-HEAD*/
select 
	ID
	,cast(t4.kpu_rcd as varchar) employeeID
	,taxCode
	,tabNum
	,dateFrom
	,dateTo
	,description
	,case when payOutID is null then '' else payOutID end payOutID
	,case when personalAccount is null then '' else personalAccount end personalAccount
	,case when appointment.employeeNumberID is null then '' else appointment.appointmentDate end appointmentDate -- ���� ����������� �� ������� ������
	,case when appointment.employeeNumberID is null then '' else appointment.appointmentOrderDate end appointmentOrderDate
	,case when appointment.employeeNumberID is null then '' else appointment.appointmentOrderNumber end appointmentOrderNumber
from (
	select 
		ID
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
		,tabNum
		,dateFrom
		,dateTo
		,description
		,payOutID
		,personalAccount
	from (
		select 
			cast(x1.kpu_rcd as varchar) ID	
			,cast(x1.kpu_tn as varchar) tabNum	 
			,cast(cast(c1.kpu_dtpst as date) as varchar) dateFrom	
			,cast(cast(case when c1.kpu_dtuvl <= '1876-12-31' then '9999-12-31' else c1.kpu_dtuvl end as date) as varchar) dateTo	
			,c1.kpu_fio +'[' + CAST(x1.kpu_tn as varchar(10)) + ']' description	
			,null payOutID	
			,null personalAccount
			,coalesce(x2.kpu_rcd, x1.kpu_rcd) kpu_rcdOsn
		from kpux x1
		inner join KPUC1 c1 on c1.Kpu_Rcd = x1.kpu_rcd
		inner join KPUK1 k1 on k1.Kpu_Rcd = x1.kpu_rcd
		left join kpux x2 on x2.kpu_tn = x1.kpu_tnosn
		where x1.kpu_tn < 4000000000
			and { fn MOD( { fn TRUNCATE( Kpu_Flg / 64, 0 ) }, 2 ) } = 0
			and (c1.kpu_flg & 2) = 0
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
---
left join ( -- appointmentDate (���� ����������� �� ������� ������)
	select 	
		cast(cast(p2.kpuprkz_dtv as date) as varchar) appointmentDate
			,case when p2.kpuprkz_dt <= '1876-12-31' then '' else cast(cast(p2.kpuprkz_dt as date) as varchar) end appointmentOrderDate
			,p2.kpuprkz_cd appointmentOrderNumber
			,p1.kpu_rcd employeeNumberID	
	from kpuc1 c1
	inner join kpux x1 on x1.kpu_rcd = c1.kpu_rcd
	inner join kpuprk1 p1 on p1.kpu_rcd = c1.kpu_rcd -- current position
		and p1.bookmark = (
			select max(p2.bookmark)
			from kpuprk1 p2
			where p2.kpu_rcd = c1.kpu_rcd
			and p2.kpuprkz_dtv = (
				select max(p3.kpuprkz_dtv)
				from kpuprk1 p3
				where p3.kpu_rcd = c1.kpu_rcd
				and p3.kpuprkz_dtv <= @dateTo
			)
		)
	inner join kpuprk1 p2 on p1.kpu_rcd = c1.kpu_rcd -- appointment date, appointment order date and number
		and p2.bookmark = (
			select max(p3.bookmark)
			from kpuprk1 p3
			where p3.kpu_rcd = c1.kpu_rcd
			and p3.kpuprkz_dtv = (
				select max(p4.kpuprkz_dtv)
				from kpuprk1 p4
				where p4.kpu_rcd = c1.kpu_rcd
				and p4.kpuprkz_dtv <= @dateTo
				and (cast(p4.KpuPrkz_Rk as bigint) & 4) <> 0
			)
		)	
	where 1=1
--	and (c1.kpu_dtuvl <= '1876-12-31' or kpu_dtuvl >= @dateFrom)
	and p2.kpuprkz_dtv > '1876-12-31'
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
) appointment on appointment.employeeNumberID = t2.ID
