-- Сальдо по місяцям (hr_accrualBalance)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @sprpdr_cd nvarchar(20) = /*SPRPDR_CD*/
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
declare @employeeDateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 0) * 10000 + 101 as varchar(10)) as date)))
declare @currentPeriod date = (
	select CASE WHEN LEN (RTRIM(CrtParm_Val)) = 8 THEN CONVERT(DATE, CrtParm_Val, 3) ELSE	CONVERT(DATE, CrtParm_Val, 103) END
	from vwCrtParm
	where crtParm_cdBpr = 2
	and crtParm_id = 'Period_DatOpen'
	and (@sysste_rcd is null or CrtFrm_Rcd = @sysste_rcd)
)
select
	cast(s1.bookmark as varchar) ID
	,cast(x1.kpu_rcd as varchar) employeeNumberID
	,cast(cast(s1.kpurl_datUp as date) as varchar) periodCalc
	,cast(case when s1.kpurl_sf = 0 then null else s1.kpurl_sf end as varchar) dictFundSourceID
	,cast(CONVERT(DECIMAL(19, 0), s1.kpurl_sin) / 100 as varchar) sumFrom
	,cast(CONVERT(DECIMAL(19, 0), s1.kpurl_nch) / 100 as varchar) sumPlus
	,cast(CONVERT(DECIMAL(19, 0), s1.kpurl_udr - coalesce(t1.kpurl_sm, 0)) / 100 as varchar) sumMinus
	,cast(CONVERT(DECIMAL(19, 0), coalesce(t1.kpurl_sm, 0)) / 100 as varchar) sumPay
	,cast(CONVERT(DECIMAL(19, 0), s1.kpurl_sout) / 100 as varchar) sumTo
from kpurlonus s1
inner join kpux x1 on x1.kpu_tn = s1.kpu_tn
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

left join (
	select r1.kpu_tn
		,r1.kpurl_datup
		,0 kpurl_sf
		,sum(r1.kpurl_sm) kpurl_sm
	from kpurlo1 r1
	inner join kpux x2 on x2.kpu_tn = r1.kpu_tn
	inner join kpuc1 c2 on c2.kpu_rcd = x2.kpu_rcd
	inner join payvo1 v1 on v1.vo_cd = r1.kpurl_cdvo
	where r1.KpuRl_CdVo <> 0
		and r1.KpuRl_DatUp >= @dateFrom
		and (r1.KpuRl_Prz & 65536) = 0 -- ������ ����������� ������������ - ����������
		and (r1.KpuRl_DatUp < @currentPeriod or {fn MOD({fn TRUNCATE(KpuRl_Prz / 1, 0)}, 2)} = 0)
		and v1.vo_grp = 130 -- �������
		and (@sysste_rcd is null or c2.kpuc_se = @sysste_rcd)
		and (c2.kpu_dtuvl <= '1876-12-31' or c2.kpu_dtuvl >= @employeeDateFrom)
	group by r1.kpu_tn, r1.kpurl_datup
	union all
	select r1.kpu_tn
		,r1.kpurl_datup
		,r1.kpurl_sf
		,sum(r1.kpurl_sm) kpurl_sm
	from kpurlo1 r1
	inner join kpux x2 on x2.kpu_tn = r1.kpu_tn
	inner join kpuc1 c2 on c2.kpu_rcd = x2.kpu_rcd
	inner join payvo1 v1 on v1.vo_cd = r1.kpurl_cdvo
	where r1.KpuRl_CdVo <> 0
		and r1.kpurl_sf <> 0
		and r1.KpuRl_DatUp >= @dateFrom
		and (r1.KpuRl_Prz & 65536) = 0 -- ������ ����������� ������������ - ����������
		and (r1.KpuRl_DatUp < @currentPeriod or {fn MOD({fn TRUNCATE(KpuRl_Prz / 1, 0)}, 2)} = 0)
		and v1.vo_grp = 130 -- �������
		and (@sysste_rcd is null or c2.kpuc_se = @sysste_rcd)
		and (c2.kpu_dtuvl <= '1876-12-31' or c2.kpu_dtuvl >= @employeeDateFrom)
	group by r1.kpu_tn, r1.kpurl_datup, r1.kpurl_sf
) t1 on t1.kpu_tn = s1.kpu_tn and t1.kpurl_datup = s1.kpurl_datup and t1.kpurl_sf = s1.kpurl_sf
where s1.kpurl_datup between @dateFrom and dateAdd(day, -1, @currentPeriod)
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
	and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)