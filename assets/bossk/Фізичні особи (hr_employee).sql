declare @orgID bigint = (case when /*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = /*OKPO*/), -1) end)
select
    Auto_Card ID
    ,coalesce(Name, '') lastName
    ,coalesce(Name_i, '') firstName
    ,coalesce(Name_o, '') middleName
    ,coalesce(Full_Name, '') fullFIO
    ,case when Sex = 0 then 'M' when Sex = 1 then 'W' else '' end sexType
    ,cast(cast(Date_birth as date) as varchar) birthDate
    -- ,Citizenship citizenshipID -- cdn_country
    ,coalesce(INN, '') taxCode
    ,coalesce(EMail, '') email
    ,'NEW' state
from Card
where Auto_Card in (
	select distinct p1.Auto_Card
	from people p1
	where (@orgID is null or @orgID = p1.id_Firm)
)
order by Full_Name