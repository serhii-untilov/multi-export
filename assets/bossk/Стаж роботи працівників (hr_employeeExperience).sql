declare @orgID bigint = (case when ''/*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = ''/*OKPO*/), -1) end)
select 
	employeeID, employeeNumberID, dictExperienceID,
	sum(DATEDIFF(day, dateFrom, dateTo)) days,
	max(dateTo) dateTo,
	cast(cast(cast(max(dateTo) as datetime) - sum(DATEDIFF(day, dateFrom, dateTo)) as date) as varchar) calcDate,
	max(dateTo) startCalcDate
from (
	SELECT 
		st1.auto_card employeeID,
		people.pId employeeNumberID,
		st1.vpr_wk_total_id_tot dictExperienceID,
		cast(cast( case when st1.date_b between '1901-01-01' and GETDATE() then st1.date_b 
				when people.in_date between '1901-01-01' and GETDATE() then people.in_date
				else GETDATE() end
			as date) as varchar) dateFrom,
		cast(cast( case when st1.date_e between '1901-01-01' and GETDATE() then st1.date_e 
				when people.out_date between '1901-01-01' and GETDATE() then people.out_date
				else GETDATE() end
			as date) as varchar) dateTo
	FROM PR_WK_TOTALS_I st1
	inner join people ON people.Auto_Card = st1.Auto_Card 
	where people.sovm <> 2
	    and (@orgID is null or @orgID = people.id_Firm)
) t1
where t1.dateFrom <= t1.dateTo
group by employeeID, employeeNumberID, dictExperienceID
order by employeeID, employeeNumberID, dictExperienceID