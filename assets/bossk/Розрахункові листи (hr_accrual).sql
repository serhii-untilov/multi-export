declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
declare @minDate date = DATEADD(YEAR, DATEDIFF(year, 0, DATEADD(month, -18, DATEADD(month, DATEDIFF(month, 0, getDate()), 0))), 0)
select -- c1.Full_Name, p1.Num_Tab, d1.Name_Pay, 
	ID = Auto_Lic
	,periodCalc = cast(cast(DATEADD(month, DATEDIFF(month, 0, dbo.zrp_fn_CMONTHTOD(l1.days, l1.cmonth)), 0) as date) as varchar)
	,periodSalary = cast(cast(DATEFROMPARTS(l1.tYear, l1.tMonth, 1) as date) as varchar)
	,tabNum = p1.Num_Tab
	,employeeNumberID = l1.pId
	,payElID = l1.Code_Pay
--	,baseSum = null
	,rate = case when l1."Percent" = 0 then '' when l1."Percent" is null then '' else cast(l1."Percent" as varchar) end
	,paySum = case when l1.Summa is null then '' when l1.Summa = 0 then '' else cast(round(l1.Summa, 2) as varchar) end
	,case when t1.days is null or t1.days = 0 then '' else cast(t1.days as varchar) end days
	,case when t1.hours is null or t1.hours = 0 then '' else cast(t1.hours as varchar) end hours
--	,planHours = null
--	,planDays = null
	,case when t1.D_FROM = '1900-01-01' then '' 
		when t1.D_FROM is null then ''
		else cast(cast(t1.D_FROM as date) as varchar) end dateFrom
	,case when t1.D_TO = '1900-01-01' then '' 
		when t1.D_TO is null then ''
		else cast(cast(t1.D_TO as date) as varchar) end dateTo
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
