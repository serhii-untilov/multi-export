-- Îñâ³òà (hr_employeeEducation)
/*BEGIN-OF-HEAD*/
select 
	'ID' ID	
	,'employeeID' employeeID
	,'taxCode' taxCode
	,'fullFIO' fullFIO
	,'birthDate' birthDate
	,'dictEducationLevelID' dictEducationLevelID
	,'dictAreasOfEduID' dictAreasOfEduID	
	,'educationName' educationName	
	,'dateFrom' dateFrom	
	,'dateTo' dateTo	
	,'educationForm' educationForm	
	,'dictSpecialtyID' dictSpecialtyID	
	,'qualification' qualification	
	,'dictDegreeID' dictDegreeID	
	,'employeeDocID' employeeDocID	
	,'dictDocKindID' dictDocKindID	
	,'docNumber' docNumber	
	,'docSeries' docSeries	
	,'docIssuer' docIssuer	
	,'dateIssue' dateIssue	
	,'comment' comment	
	,'educationLevelCode' educationLevelCode	
	,'shortEducationName' shortEducationName	
	,'accreditationLevel' accreditationLevel	
	,'specCode' specCode	
	,'courseYear' courseYear	
	,'retraining' retraining	
	,'byStateDir' byStateDir	
	,'byStateMoney' byStateMoney	
	,'intlCert' intlCert	
	,'UNESCO' UNESCO	
	,'actualCurOrg' actualCurOrg	
	,'isMain' isMain	
	,'educationOrgID ' educationOrgID
union all
/*END-OF-HEAD*/
select 
	cast(o1.KpuObr_Rcd as varchar) ID	
	,cast(o1.kpu_rcd as varchar) employeeID	
	,c1.kpu_cdnlp taxCode
	,c1.kpu_fio fullFIO
	,case when c1.kpu_dtroj <= '1876-12-31' then '' else cast(cast(c1.kpu_dtroj as date) as varchar) end birthDate 
	,'' dictEducationLevelID	
	,'' dictAreasOfEduID	
	,k1.Ptn_Nm educationName	
	,cast(o1.KpuObr_Pst as varchar) + '09-01' dateFrom	
	,cast(o1.KpuObr_End as varchar) + '05-01' dateTo
	,s1.spr_nm educationForm	
	,cast(o1.KpuObr_SpcCd as varchar) dictSpecialtyID
	,o1.KpuObr_Kvl qualification	
	,cast(o1.KpuObr_UrObrCd as varchar) dictDegreeID
	,'' employeeDocID	
	,cast(o1.KpuObr_TypDoc + 1000 as varchar) dictDocKindID
	,o1.KpuObr_NmrD docNumber
	,o1.KpuObr_SerDoc docSeries	
	,'' docIssuer
	,'' dateIssue	
	,'' comment	
	,cast(o1.KpuObr_UrObrCd as varchar) educationLevelCode	
	,o1.KpuObr_UrObr shortEducationName	
	,'' accreditationLevel	
	,cast(o1.KpuObr_SpcCd as varchar) specCode	
	,cast(o1.KpuObr_CrsUch as varchar) courseYear	
	,'' retraining	
	,'' byStateDir	
	,cast(o1.KpuObr_Opl as varchar) byStateMoney	
	,'' intlCert	
	,'' UNESCO	
	,'' actualCurOrg	
	,'' isMain	
	,cast(o1.KpuObr_ZavRcd as varchar) educationOrgID -- !!!
from kpuobr1 o1
inner join kpuc1 c1 on c1.kpu_rcd = o1.kpu_rcd
left join /*SYS_SCHEMA*/i711_sys.dbo.sspr s1 on s1.sprspr_cd = 681008 and s1.spr_cdlng = 2 and s1.spr_cd = o1.KpuObr_Form
left join PtnRk k1 on k1.Ptn_Rcd = o1.KpuObr_ZavRcd

