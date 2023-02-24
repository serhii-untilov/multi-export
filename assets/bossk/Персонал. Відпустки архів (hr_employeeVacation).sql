declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select 
    pr_Leave.Auto_Leave as ID,
    people.Auto_Card as employeeID,
    people.pId as employeeNumberID,
    typ_Leave.Code_Leave as dictVacationKindID,
    cast(cast(pr_Leave.FromD as date) as varchar) dateFrom,
    cast(cast(pr_Leave.ToD as date) as varchar) dateTo,
    Workdays_tot dayCount,
    PR_ORDERS.Name orderNumber,
    cast(cast(PR_ORDERS.Date_Sign as date) as varchar) orderDate,
    0 as isMoneyHelp
from pr_Leave
join people ON people.pid = pr_Leave.pId
join typ_Leave on pr_Leave.Code_Leave = typ_Leave.Code_Leave
left join PR_ORDERS on pr_Leave.Refer_Num = PR_ORDERS.Refer_Num
where people.out_date = '1900-01-01'
    and typ_Leave.Code_Operat <> 3
    and (@orgID is null or @orgID = people.id_Firm)