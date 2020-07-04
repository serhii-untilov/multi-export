-- ���������� �������� ���-����� - ���������� (hr_timeSheetChangeEmp)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
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
where g1.kpuigr_datEnd <= '1876-12-31' or g1.kpuigr_datEnd >= @dateFrom
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
