-- ПДФО за видами доходу (hr_taxIndividAcc)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @sprpdr_cd nvarchar(20) = /*SPRPDR_CD*/
declare @currentPeriod date = (
	select CASE WHEN LEN (RTRIM(CrtParm_Val)) = 8 THEN CONVERT(DATE, CrtParm_Val, 3) ELSE	CONVERT(DATE, CrtParm_Val, 103) END
	from vwCrtParm
	where crtParm_cdBpr = 2
	and crtParm_id = 'Period_DatOpen'
	and (@sysste_rcd is null or CrtFrm_Rcd = @sysste_rcd)
)
declare @dateFrom date = dateadd(month, -6, @currentPeriod)
declare @employeeDateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 0) * 10000 + 101 as varchar(10)) as date)))
select
	cast(p1.bookmark as varchar) ID
	,cast(r1.bookmark as varchar) accrualID
	,cast(p1.kpurlpdx_vdx as varchar) taxIndividID
	,cast(CONVERT(DECIMAL(19, 2), CONVERT(DECIMAL(19, 0), p1.kpurlpdx_sm) / 100) as varchar) taxSum
	,case when vdx.kpurl_sm is not null then
		cast(CONVERT(DECIMAL(19, 2), CONVERT(DECIMAL(19, 0), vdx.kpurl_sm) / 100) as varchar)
		else '0' end incomeSum
	,'0' privilegeSum
	,null taxLimitID1
	,null taxLimitID2
	,null taxLimitID3
	,cast(r1.kpu_tn as varchar) tabNum
	,cast(cast(r1.kpurl_datup as date) as varchar) periodCalc
	,cast(cast(r1.kpurl_datrp as date) as varchar) periodSalary
from KpuRlOPdxMon p1
inner join kpurlo1 r1 on r1.kpu_tn = p1.kpu_tn
	and r1.kpurl_datrp = p1.kpurl_datrp
	and r1.kpurl_rcd = p1.kpurl_rcd
inner join kpux x1 on x1.kpu_tn = r1.kpu_tn
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

inner join payvo1 v1 on v1.vo_cd = r1.kpurl_cdvo and v1.vo_met = 207
left join (
	select r2.kpu_tn, r2.kpurl_datrp, r2.kpurl_datup, tv.kpurlpdx_vdx, sum(r2.kpurl_sm) kpurl_sm
	from kpurlo1 r2
	inner join (
		select
			paytv.bookmark ID
			,paytv.paytv_cdt kpurlpdx_vdx
			,paytv.paytv_cdv payElID
			,paytv.paytv_dat dateFrom
			,case when vnext.paytv_dat is not null then vnext.paytv_dat - 1 else '9999-12-31' end dateTo
		from paytv
		inner join pspr vdx on vdx.sprspr_cd = 133666 and vdx.spr_cd = paytv_cdt
		inner join PAYVO1 v1 on v1.vo_cd = paytv.paytv_cdv
		inner join PSPR v2 on v2.SprSpr_Cd = 787202 and v2.spr_cd = v1.Vo_Cd
		left join paytv vnext on vnext.bookmark = (
			select max(v3.bookmark)
			from paytv v3
			where v3.paytv_part = paytv.paytv_part
				and v3.paytv_cd = paytv.paytv_cd
				and v3.paytv_nmr = paytv.paytv_nmr
				and v3.PayTV_CdT = paytv.PayTV_CdT
				and v3.paytv_dat = (
					select min(v4.paytv_dat)
					from paytv v4
					where v4.paytv_part = paytv.paytv_part
						and v4.paytv_cd = paytv.paytv_cd
						and v4.paytv_nmr = paytv.paytv_nmr
						and v4.PayTV_CdT = paytv.PayTV_CdT
						and v4.paytv_dat > paytv.paytv_dat
				)
			)
		where paytv.paytv_part = 3
			and paytv.paytv_cd = 207
			and paytv.paytv_nmr = 33
	) tv on tv.payElID = r2.kpurl_cdvo and r2.kpurl_datrp between tv.dateFrom and tv.dateTo
	where
		r2.KpuRl_CdVo <> 0
		and r2.KpuRl_DatRp >= @dateFrom
		and (r2.KpuRl_Prz & 65536) = 0 -- ������ ����������� ������������ - ����������
		and (r2.KpuRl_DatUp < @currentPeriod or {fn MOD({fn TRUNCATE(r2.KpuRl_Prz / 1, 0)}, 2)} = 0)
	group by r2.kpu_tn, r2.kpurl_datrp, r2.kpurl_datup, tv.kpurlpdx_vdx
) vdx on vdx.kpu_tn = p1.kpu_tn
	and vdx.kpurl_datrp = p1.kpurl_datrp
	and vdx.kpurl_datup = r1.kpurl_datup
	and vdx.kpurlpdx_vdx = p1.kpurlpdx_vdx
where
	r1.KpuRl_CdVo <> 0
	and r1.KpuRl_DatUp >= @dateFrom
	and (r1.KpuRl_Prz & 65536) = 0 -- ������ ����������� ������������ - ����������
	--and (r1.KpuRl_DatUp < @currentPeriod or {fn MOD({fn TRUNCATE(r1.KpuRl_Prz / 1, 0)}, 2)} = 0)
	--and (r1.KpuRl_DatUp < @currentPeriod or {fn MOD({fn TRUNCATE(KpuRl_Prz / 2048, 0)}, 2)} = 0)
	and r1.KpuRl_DatUp < @currentPeriod
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
	and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)