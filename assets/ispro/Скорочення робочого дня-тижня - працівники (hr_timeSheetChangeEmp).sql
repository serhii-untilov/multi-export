-- ���������� �������� ���-����� - ���������� (hr_timeSheetChangeEmp)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @sprpdr_cd nvarchar(20) = /*SPRPDR_CD*/
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
declare @employeeDateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 0) * 10000 + 101 as varchar(10)) as date)))
declare @shiftID bigint = 100000
/*BEGIN-OF-HEAD*/
select
	'ID' ID
	,'timeSheetChangeID' timeSheetChangeID
	,'employeeNumberID' employeeNumberID
union all
/*END-OF-HEAD*/
select
	cast(g1.bookmark + @shiftID as varchar) ID
	,cast(g1.bookmark + @shiftID as varchar) timeSheetChangeID
	,cast(g1.kpu_rcd as varchar) employeeNumberID
from KpuIgrB g1
inner join kpuc1 c1 on c1.kpu_rcd = g1.kpu_rcd

inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
	select max(pdr2.bookmark)
	from kpuprk1 pdr2
	where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
		select max(pdr3.kpuprkz_dtv)
		from kpuprk1 pdr3
		where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
	)
) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

where g1.kpuigr_datEnd <= '1876-12-31' or g1.kpuigr_datEnd >= @dateFrom
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
	and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)
