declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select
    pr_Leave.Auto_Leave ID,
    people.Auto_Card employeeID,
    people.pId employeeNumberID,
    typ_Leave.Code_Leave dictVacationKindID,
    cast(cast(pr_Leave.FromD as date) as varchar) dateFrom,
    cast(cast(pr_Leave.ToD as date) as varchar) dateTo,
    Workdays_tot dayCount,
    PR_ORDERS.Name orderNumber,
    cast(cast(PR_ORDERS.Date_Sign as date) as varchar) orderDate,
    0 isMoneyHelp
from pr_Leave
join people ON people.pid = pr_Leave.pId
join typ_Leave on pr_Leave.Code_Leave = typ_Leave.Code_Leave
left join PR_ORDERS on pr_Leave.Refer_Num = PR_ORDERS.Refer_Num
where (people.out_date = '1900-01-01' or people.out_date>='2022-01-01')
    and typ_Leave.Code_Operat <> 3
    and (@orgID is null or @orgID = people.id_Firm)
