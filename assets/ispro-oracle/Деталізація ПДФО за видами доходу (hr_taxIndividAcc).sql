-- Деталізація ПДФО за видами доходу (hr_taxIndividAcc)
WITH currentPeriod AS (
    SELECT /*+ MATERIALIZE */
        CASE 
            WHEN LENGTH(TRIM(v1.CrtParm_Val)) = 8 THEN TO_DATE(v1.CrtParm_Val, 'DD/MM/RR') 
            ELSE TO_DATE(v1.CrtParm_Val, 'DD/MM/YYYY') 
        END AS dateFrom
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.vwCrtParm v1
    /*SYSSTE_BEGIN*/
    JOIN (
        SELECT MAX(sysste_rcd) AS sysste_rcd
        FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
        WHERE sysste_cd = /*SYSSTE_CD*/'1500'
    ) ste1 ON ste1.sysste_rcd = v1.CrtFrm_Rcd
    /*SYSSTE_END*/
    WHERE v1.crtParm_cdBpr = 2 
      AND v1.crtParm_id = 'Period_DatOpen'
),
paytvPeriod AS (
	select /*+ MATERIALIZE */
		t1.bookmark ID
		,t1.paytv_cdt kpurlpdx_vdx
		,t1.paytv_cdv payElID
		,t1.paytv_dat dateFrom
		,COALESCE((
			SELECT min(t2.paytv_dat) -1
			FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.paytv t2
			WHERE t2.paytv_part = t1.paytv_part 
				and t2.paytv_cd = t1.paytv_cd
				and t2.paytv_nmr = t1.paytv_nmr
				and t2.PayTV_CdT = t1.PayTV_CdT
				and t2.paytv_dat > t1.paytv_dat
				---
				AND t2.paytv_part = 3
				and t2.paytv_cd = 207
				and t2.paytv_nmr = 33
			), TO_DATE('9999-12-31', 'YYYY-MM-DD')
		 ) dateTo
	 FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.paytv t1
	 where t1.paytv_part = 3
			and t1.paytv_cd = 207
			and t1.paytv_nmr = 33
)
select 
	p1.bookmark "ID"
	,r1.bookmark "accrualID"
	,p1.kpurlpdx_vdx "taxIndividID"
	,p1.kpurlpdx_sm / 100 "taxSum"
	,case 
		when vdx.kpurl_sm is not null THEN vdx.kpurl_sm / 100
		else 0 
		end "incomeSum"
	,'' "privilegeSum"
	,'' "taxLimitID1"
	,'' "taxLimitID2"
	,'' "taxLimitID3"
	,r1.kpu_tn "tabNum"
	,TO_CHAR(r1.kpurl_datup, 'YYYY-MM-DD') "periodCalc"
	,TO_CHAR(r1.kpurl_datrp, 'YYYY-MM-DD') "periodSalary"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.KpuRlOPdxMon p1
join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpurlo1 r1 on r1.kpu_tn = p1.kpu_tn 
	and r1.kpurl_datrp = p1.kpurl_datrp 
	and r1.kpurl_rcd = p1.kpurl_rcd
join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 on x1.kpu_tn = r1.kpu_tn
join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = x1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.payvo1 v1 on v1.vo_cd = r1.kpurl_cdvo and v1.vo_met = 207	
left join (
	select r2.kpu_tn, r2.kpurl_datrp, r2.kpurl_datup, tv.kpurlpdx_vdx, sum(r2.kpurl_sm) kpurl_sm
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpurlo1 r2
	join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x2 on x2.kpu_tn = r2.kpu_tn
	join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c2 on c2.kpu_rcd = x2.kpu_rcd
	/*SYSSTE_BEGIN*/
	JOIN (
	    SELECT MAX(sysste_rcd) AS sysste_rcd
	    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
	    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
	) ste2 ON ste2.sysste_rcd = c2.kpuc_se
	/*SYSSTE_END*/
	join paytvperiod tv on tv.payElID = r2.kpurl_cdvo and r2.kpurl_datrp between tv.dateFrom and tv.dateTo
	CROSS JOIN currentPeriod cp
	where	
		r2.KpuRl_CdVo <> 0
		and r2.KpuRl_DatRp >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
		and BITAND(r2.KpuRl_Prz, 65536) = 0 -- 
		and (r2.KpuRl_DatUp < cp.dateFrom or BITAND(r2.KpuRl_Prz, 1) = 0)	
	group by r2.kpu_tn, r2.kpurl_datrp, r2.kpurl_datup, tv.kpurlpdx_vdx
) vdx on vdx.kpu_tn = p1.kpu_tn 
	and vdx.kpurl_datrp = p1.kpurl_datrp
	and vdx.kpurl_datup = r1.kpurl_datup
	and vdx.kpurlpdx_vdx = p1.kpurlpdx_vdx
where	
	r1.KpuRl_CdVo <> 0
	and r1.KpuRl_DatUp >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
	and BITAND(r1.KpuRl_Prz, 65536) = 0 -- 
	--and (r1.KpuRl_DatUp < @currentPeriod or {fn MOD({fn TRUNCATE(r1.KpuRl_Prz / 1, 0)}, 2)} = 0)
	--and (r1.KpuRl_DatUp < @currentPeriod or {fn MOD({fn TRUNCATE(KpuRl_Prz / 2048, 0)}, 2)} = 0)
	AND r1.KpuRl_DatUp < (SELECT dateFrom FROM currentPeriod)
