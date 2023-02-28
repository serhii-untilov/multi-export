declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select  
	n1.Auto_Const_Pay ID
	,p1.Auto_Card employeeID
	,n1.pID employeeNumberID
--    ,p1.id_Firm organizationID
	,coalesce(p1.Num_Tab, '') + (case when overallNum > 1 then '.' + cast(num as varchar) else '' end) tabNum
	,c1.INN taxCode
	,n1.Code_Pay payElID
	,cast(cast(n1.FromD as date) as varchar) dateFrom
	,cast(cast((case when n1.ToD in ('1900-01-01', '2099-01-01') then '9999-12-31' else n1.ToD end) as date) as varchar) dateTo
	,Summa accrualSum
	,"Percent" accrualRate
from const_pay n1
inner join people p1 on p1.pID = n1.pID
inner join Card c1 on c1.Auto_Card = p1.Auto_Card
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
where (@orgID is null or @orgID = p1.id_Firm)
order by n1.pID, n1.FromD, n1.Code_Pay