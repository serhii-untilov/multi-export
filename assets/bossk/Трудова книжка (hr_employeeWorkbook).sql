declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
SELECT
    HIS.id_tot_i as ID,
    HIS.Auto_Card as employeeID,
    CONVERT(nvarchar,HIS.date_b,110) as dateFrom,
    case when his.date_e = '1900-01-01 00:00:00.000' then '12-31-9999' else CONVERT(nvarchar,his.date_e,110) end  as dateTo,
    'Не вказано'  as workPlace,
    'Не вказано'  as workPosition
from PR_WK_TOTALS_I his
join people  ON people.Auto_Card = HIS.Auto_Card 
where people.out_date = '1900-01-01'
    and people.sovm <> 2
    and his.vpr_wk_total_id_tot =2
    and (@orgID is null or @orgID = people.id_Firm)
