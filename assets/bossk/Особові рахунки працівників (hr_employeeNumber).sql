declare @orgID bigint = (case when /*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = /*OKPO*/), -1) end)
select 
	p1.pid ID
	,p1.Auto_Card employeeID
	,p1.id_Firm orgID
	,cast(cast(p1.in_date as date) as varchar) dateFrom
	,cast(cast((case when p1.out_date in ('1900-01-01', '2099-01-01') then '9999-12-31' else p1.out_date end) as date) as varchar) dateTo
	,coalesce(p1.Num_Tab, '') tabNum
	,coalesce(c1.INN, coalesce(c1.Passp_ser, '') + coalesce(c1.Passp_num, '')) taxCode
	,coalesce(c1.Full_Name, coalesce(Name, '') + ' ' + coalesce(Name_i, '') + ' ' + coalesce(Name_o, '')) + ' [' + coalesce(p1.Num_Tab, '') + ']' description
from people p1
inner join Card c1 on c1.Auto_Card = p1.Auto_Card
where (@orgID is null or @orgID = p1.id_Firm)
order by p1.id_Firm, p1.Num_Tab