declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select
	100000 + card.Auto_Card ID,
	card.Auto_Card employeeID,
	coalesce(t1.Code, '') dictDocKindID,
	Passp_ser docSeries,
	Passp_num docNumber,
	Passp_grant docIssued,
	cast(cast(Passp_date as date) as varchar) docIssuedDate,
	1 state
from card 
inner join people  ON people.Auto_Card = card.Auto_Card 
left join TypUdost t1 on t1.Code = TypUdost
where people.out_date = '1900-01-01'
	and people.sovm <> 2
	and (@orgID is null or @orgID = people.id_Firm)

UNION

select 
	200000 + card.Auto_Card ID,
	card.Auto_Card employeeID,
	109 dictDocKindID,  
	Seria_CC docSeries,
	Number_CC docNumber,
	'' docIssued,
	'' docIssuedDate,
	1 state
from card 
inner join people ON people.Auto_Card = card.Auto_Card 
where people.out_date = '1900-01-01'
	and people.sovm <> 2 
	and (@orgID is null or @orgID = people.id_Firm)

UNION
 
select 
	300000 +pr_educ.pr_ed_auto_num ID,
	PR_EDUC.Auto_Card as employeeID,
	119 as dictDocKindID,
	'' as docSeries,
	case when "Certificate" ='' then '-' else "Certificate" end as docNumber,
	VPR_ED_DEPTS.Firm_Text as docIssued,
	cast(cast(Certific_Date as date) as varchar) docIssuedDate,
	1 state
from PR_EDUC 
inner join people  ON people.Auto_Card = PR_EDUC.Auto_Card 
left join VPR_ED_DEPTS on PR_EDUC.Firm_Code = VPR_ED_DEPTS.Firm_Code
where people.out_date = '1900-01-01'
	and people.sovm <> 2 
	and (@orgID is null or @orgID = people.id_Firm)
