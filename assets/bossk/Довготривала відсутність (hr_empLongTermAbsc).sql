declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select pr_Leave.Auto_Leave as ID,
	pr_leave.pid employeeNumberID,
    coalesce(p1.Num_Tab, '') + (case when overallNum > 1 then '.' + cast(num as varchar) else '' end) tabNum,
    cast(cast(pr_Leave.FromD as date) as varchar) dateFrom,
    cast(cast(pr_Leave.ToD as date) as varchar) dateTo,
    typ_Leave.Name_Leave + ' ' + pr_Leave.Appl as description
from pr_Leave
join people p1 ON p1.pid = pr_Leave.pId
join typ_Leave on pr_Leave.Code_Leave = typ_Leave.Code_Leave
left join (
	select p2.pid,
	(	select count(*) 
		from people p3
		where p3.Num_Tab = p2.Num_Tab and p3.pid <= p2.pid
	) num
	from people p2
) p4 on p4.pid = p1.pid
left join (
	select p2.pid,
	(	select count(*) 
		from people p3
		where p3.Num_Tab = p2.Num_Tab
	) overallNum
	from people p2
) p5 on p5.pid = p1.pid
where p1.out_date = '1900-01-01'
    and p1.sovm <> 2
    and typ_Leave.Code_Operat = 3
    and (@orgID is null or @orgID = p1.id_Firm)