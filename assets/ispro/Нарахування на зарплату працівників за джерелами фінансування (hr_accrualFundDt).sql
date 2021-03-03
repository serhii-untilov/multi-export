-- (hr_accrualFundDt)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @sprpdr_cd nvarchar(20) = /*SPRPDR_CD*/
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
declare @currentPeriod date = (
	select CASE WHEN LEN (RTRIM(CrtParm_Val)) = 8 THEN CONVERT(DATE, CrtParm_Val, 3) ELSE	CONVERT(DATE, CrtParm_Val, 103) END
	from vwCrtParm 
	where crtParm_cdBpr = 2
	and crtParm_id = 'Period_DatOpen'
	and (@sysste_rcd is null or CrtFrm_Rcd = @sysste_rcd)
)
select
	cast(min(kpufa1.bookmark) as varchar) ID	
	,cast(min(kpufa1.bookmark) as varchar) accrualFundID	
	,cast(sum(kpuf_sm) as varchar) paySum		
	,case when KpuF_SF > 0 then cast(KpuF_SF as varchar) else '' end dictFundSourceID	
	,'' departmentID	
	,case when KpuF_CdSch is not null and KpuF_CdSch > 0 then cast(KpuF_CdSch as varchar) else '' end accountID
from kpufa1
inner join kpux x1 on x1.kpu_tn = kpufa1.kpuf_tn
inner join kpuc1 c1 on c1.kpu_rcd = x1.kpu_rcd

inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
	select max(pdr2.bookmark)
	from kpuprk1 pdr2 
	where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
		select max(pdr3.kpuprkz_dtv)
		from kpuprk1 pdr3
		where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
	)
) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

where kpuf_cdfnd <> 0
	and kpuf_datup between @dateFrom and (dateAdd(day, -1, @currentPeriod))
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
group by kpuf_datup, kpuf_datrp, kpuf_tn, x1.kpu_rcd, kpuf_cdfnd, kpuf_prc, KpuF_SF, KpuF_CdSch
