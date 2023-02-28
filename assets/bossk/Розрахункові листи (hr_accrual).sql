declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
declare @minDate date = DATEADD(YEAR, DATEDIFF(year, 0, DATEADD(month, -18, DATEADD(month, DATEDIFF(month, 0, getDate()), 0))), 0)
select -- c1.Full_Name, p1.Num_Tab, d1.Name_Pay, 
	ID = l1.Auto_Lic
	,periodCalc = cast(cast(DATEADD(month, DATEDIFF(month, 0, dbo.zrp_fn_CMONTHTOD(l1.days, l1.cmonth)), 0) as date) as varchar)
	,periodSalary = cast(cast(DATEFROMPARTS(l1.tYear, l1.tMonth, 1) as date) as varchar)
	,coalesce(p1.Num_Tab, '') + (case when overallNum > 1 then '.' + cast(num as varchar) else '' end) tabNum
	,employeeNumberID = l1.pId
	,payElID = l1.Code_Pay
--	,baseSum = null
	,rate = case when l1."Percent" = 0 then '' when l1."Percent" is null then '' else cast(l1."Percent" as varchar) end
	,paySum = case when l1.Summa is null then '' when l1.Summa = 0 then '' else cast(round(l1.Summa, 2) as varchar) end
	,case when t1.days is null or t1.days = 0 then '' else cast(t1.days as varchar) end days
	,case when t1.hours is null or t1.hours = 0 then '' else cast(t1.hours as varchar) end hours
--	,planHours = null
--	,planDays = null
	,case 
		when leave1.Auto_Lic is not null then cast(cast(leave1.fromD as date) as varchar)
		when ill1.Auto_Lic is not null then cast(cast(Ill1.fromD as date) as varchar)
		when t1.D_FROM = '1900-01-01' then '' 
		when t1.D_FROM is null then ''
		else cast(cast(t1.D_FROM as date) as varchar) end dateFrom
	,case 
		when leave1.Auto_Lic is not null then cast(cast(leave1.toD as date) as varchar)
		when ill1.Auto_Lic is not null then cast(cast(Ill1.toD as date) as varchar)
		when t1.D_TO = '1900-01-01' then '' 
		when t1.D_TO is null then ''
		else cast(cast(t1.D_TO as date) as varchar) end dateTo
--	,dateFromAvg = null
--	,dateToAvg = null
--	,sumAvg = null
	,l1.*
	,t1.*
from Lic l1
inner join typ_Pay d1 on d1.Code_Pay = l1.Code_Pay
inner join people p1 on p1.pId = l1.pid
inner join Card c1 on c1.Auto_Card = p1.Auto_Card
left join tabel t1 on t1.Auto_Tabel = l1.tabel_id
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
/*
left join pr_Leave leave1 on leave1.pid = p1.pid 
	and l1.Code_Pay in (151, 152) 
	and cast(DATEFROMPARTS(l1.tYear, l1.tMonth, 1) as date) <= leave1.ToD
	and EOMONTH(cast(DATEFROMPARTS(l1.tYear, l1.tMonth, 1) as date)) >= leave1.FromD
	and t1.days = leave1.days
*/
left join (
	select l2.Auto_Lic, cast(DATEFROMPARTS(l2.tYear, l2.tMonth, 1) as date) periodSalary, min(leave1.fromD) fromD, max(leave1.toD) toD -- max(leave1.Auto_Leave) Auto_Leave
	from Lic l2
	inner join typ_Pay d1 on d1.Code_Pay = l2.Code_Pay
	inner join people p1 on p1.pId = l2.pid
	inner join Card c1 on c1.Auto_Card = p1.Auto_Card
	inner join tabel t1 on t1.Auto_Tabel = l2.tabel_id
	inner join pr_Leave leave1 on leave1.pid = p1.pid 
		and cast(DATEFROMPARTS(l2.tYear, l2.tMonth, 1) as date) <= leave1.ToD
		and EOMONTH(cast(DATEFROMPARTS(l2.tYear, l2.tMonth, 1) as date)) >= leave1.FromD
		--and t1.days = leave1.days
	where l2.Code_Pay in (
		select Code_Pay 
		from typ_Pay
		where sname like '%отп%'
	)
	group by l2.Auto_Lic, cast(DATEFROMPARTS(l2.tYear, l2.tMonth, 1) as date)
) leave1 on leave1.Auto_Lic = l1.Auto_Lic 
	and leave1.periodSalary = cast(DATEFROMPARTS(l1.tYear, l1.tMonth, 1) as date)
--left join pr_Leave leave2 on leave2.Auto_Leave = leave1.Auto_Leave
left join (
	select l2.Auto_Lic, cast(DATEFROMPARTS(l2.tYear, l2.tMonth, 1) as date) periodSalary, min(Ill1.fromD) fromD, max(Ill1.toD) toD -- max(Ill1.Auto_ill) Auto_ill
	from Lic l2
	inner join typ_Pay d1 on d1.Code_Pay = l2.Code_Pay
	inner join people p1 on p1.pId = l2.pid
	inner join Card c1 on c1.Auto_Card = p1.Auto_Card
	inner join tabel t1 on t1.Auto_Tabel = l2.tabel_id
	inner join pr_Ill Ill1 on Ill1.pid = p1.pid 
		and cast(DATEFROMPARTS(l2.tYear, l2.tMonth, 1) as date) <= Ill1.ToD
		and EOMONTH(cast(DATEFROMPARTS(l2.tYear, l2.tMonth, 1) as date)) >= Ill1.FromD
		--and t1.days = Ill1.days
	where l2.Code_Pay in (
		select Code_Pay 
		from typ_Pay
		where sname like '%бол%'
	)
	group by l2.Auto_Lic, cast(DATEFROMPARTS(l2.tYear, l2.tMonth, 1) as date)
) Ill1 on Ill1.Auto_Lic = l1.Auto_Lic 
	and Ill1.periodSalary = cast(DATEFROMPARTS(l1.tYear, l1.tMonth, 1) as date)
-- left join pr_Ill Ill2 on Ill2.Auto_Ill = Ill1.Auto_Ill
where (@orgID is null or @orgID = p1.id_Firm)
and (
    cast(DATEADD(month, DATEDIFF(month, 0, dbo.zrp_fn_CMONTHTOD(l1.days, l1.cmonth)), 0) as date) >= @minDate 
    OR
    cast(DATEFROMPARTS(l1.tYear, l1.tMonth, 1) as date) >= @minDate
)
---
-- and l1.Code_Pay in (151, 152, 201, 202)
---
order by p1.Num_Tab, dbo.zrp_fn_CMONTHTOD(l1.days, l1.cmonth), d1.Code_Pay
