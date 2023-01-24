declare @orgID bigint = (case when /*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = /*OKPO*/), -1) end)
select 
	pr_educ.pr_ed_auto_num ID,
	pr_educ.Auto_Card employeeID,
	people.pId employeeNumberID,
	pr_educ."Type" dictEducationLevelID,
	left(VPR_ED_DEPTS.Firm_Text,200) educationName,
	case when date_finish is not null and date_finish > '1900-12-31' then cast(cast(date_finish as date) as varchar) else '' end dateTo,
	-- forme + 1 educationForm,
	'' docSeries,
	"Certificate" docNumber,  
	left(coalesce(VPR_ED_DEPTS.Firm_Text, ''), 200) docIssuer,
	case when Certific_Date is not null and Certific_Date > '1900-12-31' then cast(cast(Certific_Date as date) as varchar) else '' end dateIssue,
	PR_EDUC.Auto_Card employeeDocID,
	3 dictDocKindID,
	coalesce(PR_EDUC.Speciality, '') dictSpecialtyID,
	left(coalesce(VPR_ED_QUAL.Qualify_Text, ''),200) qualification
from PR_EDUC 
	inner join people  ON people.Auto_Card = PR_EDUC.Auto_Card 
	left join VPR_ED_DEPTS on PR_EDUC.Firm_Code = VPR_ED_DEPTS.Firm_Code
	left join VPR_ED_QUAL on pr_educ.Qualify = vpr_ed_qual.Qualify
where people.out_date = '1900-01-01'
	and people.sovm <> 2
	and (@orgID is null or @orgID = people.id_Firm)