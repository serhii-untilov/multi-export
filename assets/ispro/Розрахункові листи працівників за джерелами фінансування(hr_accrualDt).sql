--  (hr_accrual)
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
	cast(z1.bookmark as varchar) ID	
	,cast(r1.bookmark as varchar) accrualID	
	,cast(CONVERT(DECIMAL(19, 0), coalesce(z1.KpuRlSPZ_Sm, r1.kpurl_Sm)) / 100 as varchar) paySum	
	,cast(r1.kpurl_SF as varchar) dictFundSourceID	
	,case when pdr1.KpuPrkz_PdRcd > 0 then cast(pdr1.KpuPrkz_PdRcd as varchar) else '' end departmentID	
	,case when z1.KpuRl_CdSch is not null and z1.KpuRl_CdSch > 0 then cast(z1.KpuRl_CdSch as varchar) else '' end accountID
from kpurlo1 r1
inner join KPUX x1 on x1.Kpu_Tn = r1.Kpu_Tn
inner join KPUC1 c1 on c1.Kpu_Rcd = x1.kpu_rcd

inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
	select max(pdr2.bookmark)
	from kpuprk1 pdr2 
	where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
		select max(pdr3.kpuprkz_dtv)
		from kpuprk1 pdr3
		where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
	)
) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

inner join PAYVO1 v1 on v1.Vo_Cd = r1.kpurl_cdvo
left join kpurlospz z1 on z1.kpu_tn = r1.kpu_tn and z1.KpuRl_DatRp = r1.KpuRl_DatRp and z1.KpuRl_Rcd = r1.KpuRl_Rcd
where r1.KpuRl_CdVo <> 0
	and r1.KpuRl_DatUp >= @dateFrom
	and r1.KpuRl_DatUp < @currentPeriod
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
