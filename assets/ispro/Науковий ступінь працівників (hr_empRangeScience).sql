-- �������� ������ (hr_empRangeScience)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
select
	KpuNau_Rcd ID
	,cast(n1.kpu_rcd as varchar) employeeID
	,cast(n1.kpu_rcd as varchar) employeeNumberID
	,cast(x1.kpu_tn as varchar) tabNum
	,c1.kpu_cdnlp taxCode
	,c1.kpu_fio fullFIO
	,case when c1.kpu_dtroj <= '1876-12-31' then '' else cast(cast(c1.kpu_dtroj as date) as varchar) end birthDate 
	,KpuNau_CdOtr dictBranchScienceID	
	,KpuNau_CdNS dictDegreeID
	,s1.spr_nm dictDegreeName
	,KpuNau_CdSp dictSpecialtyID	
	,KpuNau_CdSp dictSpecialtyCode
	,case when s2.spr_nm is not null then s2.spr_nm else KpuNau_SpNm end dictSpecialtyName
	,KpuNau_Dsr educationName	
	,KpuNau_NmrD docNumber
	,cast(cast(KpuNau_DtVD as date) as varchar) docDate	
	,KpuNau_MZ comment	
	,KpuNau_YPr yearOf	
	,KpuNau_CdMZ educationOrgID
from KpuNau1 n1
inner join KPUC1 c1 ON C1.Kpu_Rcd = n1.Kpu_Rcd
inner join kpux x1 on x1.kpu_rcd = n1.kpu_rcd
left join pspr s1 on s1.sprspr_cd = 680964 and s1.Spr_Cd = n1.KpuNau_CdNS
left join pspr s2 on s2.sprspr_cd = 681003 and s2.spr_cd = KpuNau_CdSp
where n1.KpuNau_CdNS > 0
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
union all
select
	KpuNau_Rcd ID
	,cast(n1.kpu_rcd as varchar) employeeID
	,cast(n1.kpu_rcd as varchar) employeeNumberID
	,cast(x1.kpu_tn as varchar) tabNum
	,c1.kpu_cdnlp taxCode
	,c1.kpu_fio fullFIO
	,case when c1.kpu_dtroj <= '1876-12-31' then '' else cast(cast(c1.kpu_dtroj as date) as varchar) end birthDate 
	,KpuNau_CdOtr dictBranchScienceID	
	,KpuNau_CdUZ + 1000 dictDegreeID
	,s3.spr_nm dictDegreeName
	,KpuNau_CdSp dictSpecialtyID	
	,KpuNau_CdSp dictSpecialtyCode
	,case when s2.spr_nm is not null then s2.spr_nm else KpuNau_SpNm end dictSpecialtyName
	,KpuNau_Dsr educationName	
	,KpuNau_NmrD docNumber
	,cast(cast(KpuNau_DtVD as date) as varchar) docDate	
	,KpuNau_MZ comment	
	,KpuNau_YPr yearOf	
	,KpuNau_CdMZ educationOrgID
from KpuNau1 n1
inner join KPUC1 c1 ON C1.Kpu_Rcd = n1.Kpu_Rcd
inner join kpux x1 on x1.kpu_rcd = n1.kpu_rcd
--left join pspr s1 on s1.sprspr_cd = 680964 and s1.Spr_Cd = n1.KpuNau_CdNS
left join pspr s2 on s2.sprspr_cd = 681003 and s2.spr_cd = KpuNau_CdSp
LEFT JOIN pspr s3 on s3.sprspr_cd = 680981 and s3.spr_cd = n1.KpuNau_CdUZ
where n1.KpuNau_CdUZ > 0
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
