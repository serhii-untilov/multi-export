declare @orgID bigint = (case when /*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = /*OKPO*/), -1) end)
select 
	ID
	,OKPO code
	,coalesce(SNAME, NAME) name
	,coalesce(NAME, SNAME) fullName
	,coalesce(OKPO, '') EDRPOUCode
	,cast(cast(D_IN as date) as varchar) dateFrom
	,cast(cast((case when D_OUT in ('1900-01-01', '2099-01-01') then '9999-12-31' else D_OUT end) as date) as varchar) dateTo
	,coalesce(INN, '') taxCode
from HR_FIRM
where (@orgID is null or @orgID = ID)
order by OKPO