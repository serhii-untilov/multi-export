declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)

select pr_Leave.Auto_Leave as ID,
    people.Num_Tab as employeeNumberID,
    cast(cast(pr_Leave.FromD as date) as varchar) dateFrom,
    cast(cast(pr_Leave.ToD as date) as varchar) dateTo,
    typ_Leave.Name_Leave + ' ' + pr_Leave.Appl as description
from pr_Leave
join people  ON people.pid = pr_Leave.pId
join typ_Leave on pr_Leave.Code_Leave = typ_Leave.Code_Leave
where people.out_date = '1900-01-01'
    and people.sovm <> 2
    and typ_Leave.Code_Operat = 3
    and (@orgID is null or @orgID = people.id_Firm)