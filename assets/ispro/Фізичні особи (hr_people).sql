-- Фізичні особи (родичі) (hr_people)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @sprpdr_cd nvarchar(20) = /*SPRPDR_CD*/
declare @employeeDateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 0) * 10000 + 101 as varchar(10)) as date)))
select ID, firstName, lastName, middleName, shortFIO, fullFIO, birthDate,
	description,
	cast(t2.kpu_rcd as varchar) employeeID
from (
	select
		cast(u1.kpuudr_ID as varchar) ID -- ����� ����� ��������� �������
		,dbo.fnKdrSegregateFio(KpuUdr_DatRRFio, 2) firstName
		,dbo.fnKdrSegregateFio(KpuUdr_DatRRFio, 1) lastName
		,dbo.fnKdrSegregateFio(KpuUdr_DatRRFio, 3) middleName
		,dbo.fnKdrSegregateFio(KpuUdr_DatRRFio, 1) + ' ' + LEFT(dbo.fnKdrSegregateFio(KpuUdr_DatRRFio, 2), 1) + '. ' + LEFT(dbo.fnKdrSegregateFio(KpuUdr_DatRRFio, 3), 1) + '.' shortFIO
		,KpuUdr_DatRRFio fullFIO
		,cast(cast(KpuUdr_DatRR as date) as varchar) birthDate
		,KpuUdr_DatRRFio description
		,c1.Kpu_Rcd
	from KPUUDR1 u1
		inner join kpuc1 c1 on c1.kpu_rcd = u1.kpu_rcd

		inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
			select max(pdr2.bookmark)
			from kpuprk1 pdr2
			where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
				select max(pdr3.kpuprkz_dtv)
				from kpuprk1 pdr3
				where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
			)
		) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

		inner join payvo1 v1 on v1.vo_cd = u1.kpuudr_cd
		left join PtnSchk s1 on s1.ptn_rcd = u1.kpuudr_cdplc and s1.ptnsch_rcd = u1.kpuudr_cdbank
	where v1.vo_met = 19 and len(KpuUdr_DatRRFio) > 0
	and (c1.kpu_flg & 2) = 0
	union all
	select
		cast((40000000 + s1.kpusem_rcd) as varchar) ID -- ����� ����� ��������� �������
		,dbo.fnKdrSegregateFio(KpuSem_Fio, 2) firstName
		,dbo.fnKdrSegregateFio(KpuSem_Fio, 1) lastName
		,dbo.fnKdrSegregateFio(KpuSem_Fio, 3) middleName
		,dbo.fnKdrSegregateFio(KpuSem_Fio, 1) + ' ' + LEFT(dbo.fnKdrSegregateFio(KpuSem_Fio, 2), 1) + '. ' + LEFT(dbo.fnKdrSegregateFio(KpuSem_Fio, 3), 1) + '.' shortFIO
		,KpuSem_Fio fullFIO
		,cast(cast(KpuSem_Dt as date) as varchar) birthDate
		,KpuSem_Fio description
		,c1.Kpu_Rcd
	from kpusem1 s1
	inner join kpuc1 c1 on c1.kpu_rcd = s1.kpu_rcd

	inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
		select max(pdr2.bookmark)
		from kpuprk1 pdr2
		where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
			select max(pdr3.kpuprkz_dtv)
			from kpuprk1 pdr3
			where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
		)
	) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

	left join pspr on pspr.sprspr_cd = 680980 and spr_cd = KpuSem_Cd
	where (c1.kpu_flg & 2) = 0
)  t1
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
) t2 on t2.kpu_rcd = t1.kpu_rcd
