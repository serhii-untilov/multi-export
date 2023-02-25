declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select
	p1.Code_appoint ID
	,'ACCRUAL' as paymentType
	,p1.Code_appoint code
	,cast(cast(p1.d_from as date) as varchar) dateFrom
	,cast(cast((case when p1.d_to in ('1900-01-01', '2099-01-01') then '9999-12-31' else p1.d_to end) as date) as varchar) dateTo
	,p1.Name_appoint name
    ,nameGen = coalesce(p1.Name_appoint_Acc, '')
    ,nameDat = coalesce(p1.Name_appoint_Giv, '')
    ,nameOr = coalesce(p1.Name_appoint_Cre, '')
	,fullNameGen = coalesce(p1.Name_appoint_Acc, '')
    ,fullNameDat = coalesce(p1.Name_appoint_Giv, '')
	,p1.Name_appoint_Full fullName
    ,fullNameOr = coalesce(p1.Name_appoint_Cre, '')
    ,fullNameGen = coalesce(p1.Name_appoint_Acc, '')
	,nameVoc = coalesce(id_OKPDTR, '') 
	,dictStaffCatID = case
		when p1.Work_Categ is null then ''
		when p1.Work_Categ = 0 then ''
		else cast(p1.Work_Categ as varchar)
		end
from Appointments p1
join  (select max(db_id) as id, Name_appoint as  name from Appointments group by Name_appoint) grp on db_id = id
where p1.Code_appoint in (
	select distinct d1.Code_appoint 
	from PR_CURRENT d1
	where (@orgID is null or @orgID = d1.id_Firm)
)
order by p1.Code_appoint

