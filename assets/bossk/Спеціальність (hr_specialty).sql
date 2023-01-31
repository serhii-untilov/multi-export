declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select 
	speciality as ID, 
	speciality as code, 
	left(Special_Text,200) as name, 
	1 as specialityType 
from VPR_ED_SPEC 
where Special_Text <> ''
and speciality in (
	select distinct PR_EDUC.Speciality
	from PR_EDUC 
		inner join people  ON people.Auto_Card = PR_EDUC.Auto_Card 
		left join VPR_ED_DEPTS on PR_EDUC.Firm_Code = VPR_ED_DEPTS.Firm_Code
		left join VPR_ED_QUAL on pr_educ.Qualify = vpr_ed_qual.Qualify
	where people.out_date = '1900-01-01'
		and people.sovm <> 2
		and (@orgID is null or @orgID = people.id_Firm)
)
