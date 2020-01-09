-- Працівники (hr_employee)
/*BEGIN-OF-HEAD*/
select 'ID' ID, 'lastName' lastName, 'firstName' firstName, 'middleName' middleName, 'shortFIO' shortFIO, 'fullFIO' fullFIO, 'genName' genName, 'datName' datName,
	'accusativeName' accusativeName, 'insName' insName, 'tabNum' tabNum, 'state' state, 'sexType' sexType, 'birthDate' birthDate, 'taxCode' taxCode, 
	'phoneMobile' phoneMobile, 'phoneWorking' phoneWorking, 'phoneHome' phoneHome, 'email' email, 'description' description, 
	'locName' locName, 'dayBirthDate' dayBirthDate, 'monthBirthDate' monthBirthDate, 'yearBirthDate' yearBirthDate
union all
/*END-OF-HEAD*/
select 
	cast(x1.kpu_rcd as varchar) ID
	,dbo.fnKdrSegregateFio(c1.kpu_fio, 1) lastName
	,dbo.fnKdrSegregateFio(c1.kpu_fio, 2) firstName
	,dbo.fnKdrSegregateFio(c1.kpu_fio, 3) middleName
	,dbo.fnKdrSegregateFio(c1.kpu_fio, 1) + ' ' + LEFT(dbo.fnKdrSegregateFio(c1.kpu_fio, 2), 1) + '. ' + LEFT(dbo.fnKdrSegregateFio(c1.kpu_fio, 3), 1) + '. ' shortFIO
	,c1.kpu_fio fullFIO
	,c1.kpu_fioR genName
	,c1.kpu_fioD datName
	,c1.kpu_fioV accusativeName	
	,c1.kpu_fio insName
	,cast(x1.kpu_tn as varchar) tabNum	
	,'NEW' state	
	,case when c1.kpu_cdpol = 1 then 'W' when c1.kpu_cdpol = 2 then 'M' else null end sexType	
	,cast(cast(c1.kpu_dtroj as date) as varchar) birthDate	
	,t1.kpu_cdnlp taxCode	
	,Kpu_TelM phoneMobile	
	,Kpu_TelS phoneWorking	
	,Kpu_Tel phoneHome	
	,Kpu_EMail email	
	,c1.kpu_fio description	
	,c1. kpu_fio locName	
	,cast(day(c1.kpu_dtroj) as varchar) dayBirthDate	
	,cast(month(c1.kpu_dtroj) as varchar) monthBirthDate	
	,cast(year(c1.kpu_dtroj) as varchar) yearBirthDate	
from kpux x1
inner join KPUC1 c1 on c1.Kpu_Rcd = x1.kpu_rcd
inner join KPUK1 k1 on k1.Kpu_Rcd = x1.kpu_rcd
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
) t1 on t1.kpu_rcd = c1.kpu_rcd
