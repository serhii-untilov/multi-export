declare @orgID bigint = (case when /*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = /*OKPO*/), -1) end)
select 
	cast(p1.Code_appoint as varchar) ID
	,cast(p1.Code_appoint as varchar) code
	,p1.Name_appoint name
	,p1.Name_appoint_Full fullName
	,cast(cast(p1.d_from as date) as varchar) dateFrom
	,cast(cast((case when p1.d_to in ('1900-01-01', '2099-01-01') then '9999-12-31' else p1.d_to end) as date) as varchar) dateTo
	,description = ''
    ,nameGen = coalesce(p1.Name_appoint_Acc, '')
    ,nameDat = coalesce(p1.Name_appoint_Giv, '')
    ,fullNameGen = coalesce(p1.Name_appoint_Acc, '')
    ,fullNameDat = coalesce(p1.Name_appoint_Giv, '')
    ,nameOr = coalesce(p1.Name_appoint_Cre, '')
    ,fullNameOr = coalesce(p1.Name_appoint_Cre, '')
	,dictStaffCatID = coalesce(p1.Work_Categ, '')
from Appointments p1
where p1.Code_appoint in (
	select distinct d1.Code_appoint 
	from PR_CURRENT d1
	where (@orgID is null or @orgID = d1.id_Firm)
)
order by p1.Code_appoint
