declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ªÄÐÏÎÓ', '' - óñ³ îðãàí³çàö³¿
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)

select pr_Leave.Auto_Leave as ID,
people.Auto_Card as employeeID,
people.Num_Tab as employeeNumberID,
typ_Leave.Code_Leave as dictVacationKindID,
CONVERT(nvarchar,pr_Leave.FromD,110)  as dateFrom,
CONVERT(nvarchar,pr_Leave.ToD,110) as dateTo,
Workdays_tot as dayCount,
PR_ORDERS.Name as orderNumber , 
CONVERT(nvarchar,PR_ORDERS.Date_Sign,110)  as orderDate
from pr_Leave
 join people  ON people.pid = pr_Leave.pId
 join typ_Leave on pr_Leave.Code_Leave = typ_Leave.Code_Leave
 left join PR_ORDERS on pr_Leave.Refer_Num = PR_ORDERS.Refer_Num
  where people.out_date = '1900-01-01 00:00:00.000'
 and people.sovm <> 2
 and typ_Leave.Code_Operat <> 3
 and (@orgID is null or @orgID = people.id_Firm)