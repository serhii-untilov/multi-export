-- Науковий ступінь працівників (hr_empRangeScience)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @sprpdr_cd nvarchar(20) = /*SPRPDR_CD*/
declare @employeeDateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 0) * 10000 + 101 as varchar(10)) as date)))
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

inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
	select max(pdr2.bookmark)
	from kpuprk1 pdr2
	where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
		select max(pdr3.kpuprkz_dtv)
		from kpuprk1 pdr3
		where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
	)
) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

left join pspr s1 on s1.sprspr_cd = 680964 and s1.Spr_Cd = n1.KpuNau_CdNS
left join pspr s2 on s2.sprspr_cd = 681003 and s2.spr_cd = KpuNau_CdSp
where n1.KpuNau_CdNS > 0
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
	and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)
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

inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
	select max(pdr2.bookmark)
	from kpuprk1 pdr2
	where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
		select max(pdr3.kpuprkz_dtv)
		from kpuprk1 pdr3
		where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
	)
) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

--left join pspr s1 on s1.sprspr_cd = 680964 and s1.Spr_Cd = n1.KpuNau_CdNS
left join pspr s2 on s2.sprspr_cd = 681003 and s2.spr_cd = KpuNau_CdSp
LEFT JOIN pspr s3 on s3.sprspr_cd = 680981 and s3.spr_cd = n1.KpuNau_CdUZ
where n1.KpuNau_CdUZ > 0
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
	and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)
