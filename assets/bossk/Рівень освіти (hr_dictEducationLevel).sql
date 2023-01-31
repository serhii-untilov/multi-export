declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select 
	"type" as ID,
	"type" as code,
	type_text as name 
from VPR_EDUC
where "type" in (
	select distinct pr_educ."Type"
	from PR_EDUC 
		inner join people  ON people.Auto_Card = PR_EDUC.Auto_Card 
		left join VPR_ED_DEPTS on PR_EDUC.Firm_Code = VPR_ED_DEPTS.Firm_Code
		left join VPR_ED_QUAL on pr_educ.Qualify = vpr_ed_qual.Qualify
	where people.out_date = '1900-01-01'
		and people.sovm <> 2
		and (@orgID is null or @orgID = people.id_Firm)
)
union
select 
	'0' as ID,
	'0' as code,
	'Не визначено' as name
