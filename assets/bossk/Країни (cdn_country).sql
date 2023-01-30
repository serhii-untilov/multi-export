declare @orgID bigint = (case when ''/*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = ''/*OKPO*/), -1) end)
select 
    citizenship ID
    ,kod as code
    ,country as name
from pr_countries
where citizenship in (
    select distinct c1.Citizenship 
    FROM Card c1
	inner join people p1 on p1.Auto_Card = c1.Auto_Card
	where (@orgID is null or @orgID = p1.id_Firm)
)
order by citizenship