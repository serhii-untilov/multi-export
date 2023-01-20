declare @orgID bigint = (case when /*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = /*OKPO*/), -1) end)
declare @minDate date = DATEADD(YEAR, DATEDIFF(year, 0, DATEADD(month, -18, DATEADD(month, DATEDIFF(month, 0, getDate()), 0))), 0)
select -- c1.Full_Name, p1.Num_Tab, d1.Name_Pay, 
	ID = Auto_Lic
	,periodCalc = cast(cast(DATEADD(month, DATEDIFF(month, 0, dbo.zrp_fn_CMONTHTOD(l1.days, l1.cmonth)), 0) as date) as varchar)
	,periodSalary = cast(cast(DATEFROMPARTS(l1.tYear, l1.tMonth, 1) as date) as varchar)
	,tabNum = p1.Num_Tab
	,employeeNumberID = l1.pId
	,payElID = l1.Code_Pay
--	,baseSum = null
	,rate = l1."Percent"
	,paySum = l1.Summa
	,coalesce(t1.days, '') days
	,coalesce(t1.hours, '') hours
--	,planHours = null
--	,planDays = null
--	,coalesce(cast(t1.D_FROM as date), '') dateFrom
--	,coalesce(cast(t1.D_TO as date), '') dateTo
--	,dateFromAvg = null
--	,dateToAvg = null
--	,sumAvg = null
--	,l1.*
--	,t1.*
from Lic l1
inner join typ_Pay d1 on d1.Code_Pay = l1.Code_Pay
inner join people p1 on p1.pId = l1.pid
inner join Card c1 on c1.Auto_Card = p1.Auto_Card
left join tabel t1 on t1.Auto_Tabel = l1.tabel_id
where (@orgID is null or @orgID = p1.id_Firm)
and ( 
    cast(DATEADD(month, DATEDIFF(month, 0, dbo.zrp_fn_CMONTHTOD(l1.days, l1.cmonth)), 0) as date) >= @minDate 
    OR
    cast(DATEFROMPARTS(l1.tYear, l1.tMonth, 1) as date) >= @minDate
)
order by p1.Num_Tab, dbo.zrp_fn_CMONTHTOD(l1.days, l1.cmonth), d1.Code_Pay
