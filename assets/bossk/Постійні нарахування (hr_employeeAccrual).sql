declare @orgID bigint = (case when /*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = /*OKPO*/), -1) end)
select  
	n1.Auto_Const_Pay ID
	,p1.Auto_Card employeeID
	,n1.pID employeeNumberID
--    ,p1.id_Firm organizationID
	,p1.Num_Tab tabNum
	,c1.INN taxCode
	,n1.Code_Pay payElID
	,cast(cast(n1.FromD as date) as varchar) dateFrom
	,cast(cast((case when n1.ToD in ('1900-01-01', '2099-01-01') then '9999-12-31' else n1.ToD end) as date) as varchar) dateTo
	,Summa accrualSum
	,"Percent" accrualRate
from const_pay n1
inner join people p1 on p1.pID = n1.pID
inner join Card c1 on c1.Auto_Card = p1.Auto_Card
where (@orgID is null or @orgID = p1.id_Firm)
order by 