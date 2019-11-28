-- Фізичні особи (hr_people)
select 'ID' ID, 'firstName' firstName, 'lastName' lastName, 'middleName' middleName, 'shortFIO' shortFIO, 'fullFIO' fullFIO, 'birthDate' birthDate, 
	'description' description, 'employeeID' employeeID
union all
select ID, firstName, lastName, middleName, shortFIO, fullFIO, birthDate, 
	description, 
	cast(t2.kpu_rcd as varchar) employeeID
from (	
	select
		cast(u1.kpuudr_ID as varchar) ID -- здесь нужно подобрать префикс
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
		inner join payvo1 v1 on v1.vo_cd = u1.kpuudr_cd
		left join PtnSchk s1 on s1.ptn_rcd = u1.kpuudr_cdplc and s1.ptnsch_rcd = u1.kpuudr_cdbank
	where v1.vo_met = 19 and len(KpuUdr_DatRRFio) > 0
	and (c1.kpu_flg & 2) = 0
	union all 
	select 
		cast((40000000 + s1.kpusem_rcd) as varchar) ID -- здесь нужно подобрать префикс	
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
	left join pspr on pspr.sprspr_cd = 680980 and spr_cd = KpuSem_Cd
	where (c1.kpu_flg & 2) = 0
)  t1
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
) t2 on t2.kpu_rcd = t1.kpu_rcd
