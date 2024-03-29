declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select 
    ID
    ,id as code
    ,famstat as name
from VPR_WK_Fam_Stat
where ID in (
	select distinct FamilyStatus
	from Card
	where Auto_Card in (
		select distinct p1.Auto_Card
		from people p1
		where (@orgID is null or @orgID = p1.id_Firm)
	)
)
