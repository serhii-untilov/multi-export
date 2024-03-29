declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
SELECT 
	Code_Regim as id,
	Code_Regim as code,
	Name_Regim as name,
	'FROM_SCHEDULE' as begins,
	cast(cast(mdate as date) as varchar) dateFrom
from typ_regim
where Code_Regim in (
	select distinct p1.Code_Regim workScheduleID
	from PR_CURRENT p1
	inner join people n1 on n1.Auto_Card = p1.Auto_Card 
	where (@orgID is null or @orgID = p1.id_Firm)
)
order by Code_Regim