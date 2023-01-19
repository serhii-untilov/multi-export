declare @orgID bigint = (case when /*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = /*OKPO*/), -1) end)
select 
	cast(d1.Work_Categ as varchar) ID
	,cast(d1.Work_Categ as varchar) code
	,d1.Work_Categ_Name as name
	,cast(cast(d1.d_from as date) as varchar) dateFrom
	,cast(cast((case when d1.d_to in ('1900-01-01', '2099-01-01') then '9999-12-31' else d1.d_to end) as date) as varchar) dateTo
from VPR_WK_Categ d1
where d1.Work_Categ in (
	select distinct p1.Work_Categ w1
	from PR_CURRENT p1
	where (@orgID is null or @orgID = p1.id_Firm)
)
order by d1.Work_Categ