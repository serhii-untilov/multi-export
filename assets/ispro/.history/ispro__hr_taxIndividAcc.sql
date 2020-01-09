-- ПДФО за видами доходу (hr_taxIndividAcc)
declare @currentPeriod date = (
	select CASE WHEN LEN (RTRIM(CrtParm_Val)) = 8 THEN CONVERT(DATE, CrtParm_Val, 3) ELSE	CONVERT(DATE, CrtParm_Val, 103) END
	from vwCrtParm 
	where crtParm_cdBpr = 2
	and crtParm_id = 'Period_DatOpen'
)
declare @dateFrom date = dateadd(month, -6, @currentPeriod)
/*
select 
	'ID' ID
	,'accrualID' accrualID
	,'taxIndividID' taxIndividID
	,'taxSum' taxSum
	,'incomeSum' incomeSum
	,'privilegeSum' privilegeSum
	,'taxLimitID1' taxLimitID1
	,'taxLimitID2' taxLimitID2
	,'taxLimitID3' taxLimitID3
--
union all
--
*/
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
from KpuRlOPdxMon p1
inner join kpurlo1 r1 on r1.kpu_tn = p1.kpu_tn 
	and r1.kpurl_datrp = p1.kpurl_datrp 
	and r1.kpurl_rcd = p1.kpurl_rcd
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
		and (r2.KpuRl_Prz & 65536) = 0 -- Записи внутреннего совместителя - пропускаем
		and (r2.KpuRl_DatUp < @currentPeriod or {fn MOD({fn TRUNCATE(r2.KpuRl_Prz / 1, 0)}, 2)} = 0)	
	group by r2.kpu_tn, r2.kpurl_datrp, r2.kpurl_datup, tv.kpurlpdx_vdx
) vdx on vdx.kpu_tn = p1.kpu_tn 
	and vdx.kpurl_datrp = p1.kpurl_datrp
	and vdx.kpurl_datup = r1.kpurl_datup
	and vdx.kpurlpdx_vdx = p1.kpurlpdx_vdx
where	
	r1.KpuRl_CdVo <> 0
	and r1.KpuRl_DatRp >= @dateFrom
	and (r1.KpuRl_Prz & 65536) = 0 -- Записи внутреннего совместителя - пропускаем
	and (r1.KpuRl_DatUp < @currentPeriod or {fn MOD({fn TRUNCATE(r1.KpuRl_Prz / 1, 0)}, 2)} = 0)
