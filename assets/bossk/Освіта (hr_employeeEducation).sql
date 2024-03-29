declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select 
	pr_educ.pr_ed_auto_num ID,
	pr_educ.Auto_Card employeeID,
	people.pId employeeNumberID,
	dictEducationLevelID = coalesce(d1."Type", '0'),
	left(coalesce(VPR_ED_DEPTS.Firm_Text, ''),200) educationName,
	case when date_finish is not null and date_finish > '1900-12-31' then cast(cast(date_finish as date) as varchar) else '' end dateTo,
	3 educationForm,
	'' docSeries,
	"Certificate" docNumber,  
	left(coalesce(VPR_ED_DEPTS.Firm_Text, ''), 200) docIssuer,
	case when Certific_Date is not null and Certific_Date > '1900-12-31' then cast(cast(Certific_Date as date) as varchar) else '' end dateIssue,
	300000 + pr_educ.pr_ed_auto_num employeeDocID,
	119 dictDocKindID,
	case when PR_EDUC.Speciality is null then '' when PR_EDUC.Speciality = 0 then '' else cast(PR_EDUC.Speciality as varchar) end dictSpecialtyID,
	left(coalesce(VPR_ED_QUAL.Qualify_Text, ''),200) qualification
from PR_EDUC 
	inner join people  ON people.Auto_Card = PR_EDUC.Auto_Card
	left join VPR_EDUC d1 on d1."Type" = PR_EDUC."Type"
	left join VPR_ED_DEPTS on PR_EDUC.Firm_Code = VPR_ED_DEPTS.Firm_Code
	left join VPR_ED_QUAL on pr_educ.Qualify = vpr_ed_qual.Qualify
where people.out_date = '1900-01-01'
	and people.sovm <> 2
	and (@orgID is null or @orgID = people.id_Firm)
