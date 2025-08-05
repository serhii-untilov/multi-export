-- Документи (hr_employeeDocs)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @sprpdr_cd nvarchar(20) = /*SPRPDR_CD*/
declare @employeeDateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 0) * 10000 + 101 as varchar(10)) as date)))
select
	cast(d1.bookmark as varchar) ID
	,cast(d1.kpu_rcd as varchar) employeeID
	,cast(d1.kpupsp_typdoc as varchar) dictDocKindID
	,d1.kpupsp_ser docSeries
	,d1.kpupsp_nmr docNumber
	,d1.kpupsp_who docIssued
	,cast(cast(case when d1.kpupsp_dat <= '1876-12-31' then null else d1.kpupsp_dat end as date) as varchar) docIssuedDate
	,cast(cast(case when d1.kpupsp_term <= '1876-12-31' then null else d1.kpupsp_term end as date) as varchar) docValidUntil
	,cast(KpuPsp_Add + 1 as varchar) state
	,d1.kpupsp_com comment
	,s1.spr_nm
			+ case when len(s1.spr_nm) > 0 and len(d1.kpupsp_ser) > 0 then ', ' else '' end
			+ d1.kpupsp_ser
			+ case when len(d1.kpupsp_nmr) > 0 then ' � ' else '' end + d1.kpupsp_nmr
			+ case when len(s1.spr_nm + d1.kpupsp_ser + d1.kpupsp_nmr) > 0 and d1.kpupsp_dat > '1876-12-31' then ', ' else '' end
			+ case when d1.kpupsp_dat <= '1876-12-31' then '' else convert(varchar, d1.kpupsp_dat, 104) end description
	,null orderID
	,null paraID
from KpuPsp1 d1
inner join kpuc1 c1 on c1.kpu_rcd = d1.kpu_rcd

inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
	select max(pdr2.bookmark)
	from kpuprk1 pdr2
	where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
		select max(pdr3.kpuprkz_dtv)
		from kpuprk1 pdr3
		where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
	)
) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

inner join pspr s1 on s1.sprspr_cd = 513 and s1.spr_cd = d1.kpupsp_typDoc
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
) t1 on t1.kpu_rcd = c1.kpu_rcd
where (c1.kpu_flg & 2) = 0
	and (len(d1.kpupsp_ser) > 0 or len(d1.kpupsp_nmr) > 0)
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
	and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)