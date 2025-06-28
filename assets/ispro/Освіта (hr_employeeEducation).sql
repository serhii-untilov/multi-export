-- Освіта (hr_employeeEducation)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @sprpdr_cd nvarchar(20) = /*SPRPDR_CD*/
select
	cast(o1.KpuObr_Rcd as varchar) ID
	,cast(o1.kpu_rcd as varchar) employeeID
	,c1.kpu_cdnlp taxCode
	,c1.kpu_fio fullFIO
	,case when c1.kpu_dtroj <= '1876-12-31' then '' else cast(cast(c1.kpu_dtroj as date) as varchar) end birthDate
	,'' dictEducationLevelID
	,'' dictAreasOfEduID
	,k1.Ptn_Nm educationName
	,case
		when o1.KpuObr_Pst is null then 'null'
		when len(cast(o1.KpuObr_Pst as varchar)) = 4 then cast(o1.KpuObr_Pst as varchar) + '-09-01'
		else 'null'
		end dateFrom
	,case
		when o1.KpuObr_End is null then 'null'
		when len(cast(o1.KpuObr_End as varchar)) = 4 then cast(o1.KpuObr_End as varchar) + '-05-01'
		else 'null'
		end dateTo
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

inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
	select max(pdr2.bookmark)
	from kpuprk1 pdr2
	where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
		select max(pdr3.kpuprkz_dtv)
		from kpuprk1 pdr3
		where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
	)
) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

left join /*SYS_SCHEMA*/i711_sys.dbo.sspr s1 on s1.sprspr_cd = 681008 and s1.spr_cdlng = 2 and s1.spr_cd = o1.KpuObr_Form
left join PtnRk k1 on k1.Ptn_Rcd = o1.KpuObr_ZavRcd
where (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
