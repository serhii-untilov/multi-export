declare @orgID bigint = (case when ''/*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = ''/*OKPO*/), -1) end)
select 
    who_code ID,
    code,
    who_text name
from VPR_WHOISWHO
where who_code in (
	select distinct Who_Code
	from PR_RELATIV child
	inner join card empl ON child.Auto_Card = empl.Auto_Card 
	inner join people ON people.Auto_Card = empl.Auto_Card 
	where people.out_date in ('1900-01-01', '2099-01-01')
	and (@orgID is null or @orgID = people.id_Firm)
	and people.sovm <> 2
)
order by Who_code