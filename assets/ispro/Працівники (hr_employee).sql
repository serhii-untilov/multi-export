-- ���������� (hr_employee)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @sprpdr_cd nvarchar(20) = /*SPRPDR_CD*/
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
	,REPLACE(REPLACE(c1.kpu_fio, CHAR(13), ''), CHAR(10), '') fullFIO
	,REPLACE(REPLACE(c1.kpu_fioR, CHAR(13), ''), CHAR(10), '') genName
	,REPLACE(REPLACE(c1.kpu_fioD, CHAR(13), ''), CHAR(10), '') datName
	,REPLACE(REPLACE(c1.kpu_fioV, CHAR(13), ''), CHAR(10), '') accusativeName	
	,REPLACE(REPLACE(c1.kpu_fio, CHAR(13), ''), CHAR(10), '') insName
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

inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
	select max(pdr2.bookmark)
	from kpuprk1 pdr2 
	where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
		select max(pdr3.kpuprkz_dtv)
		from kpuprk1 pdr3
		where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
	)
) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

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
	) t1
	group by kpu_cdnlp
) t1 on t1.kpu_rcd = c1.kpu_rcd
where (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)