-- Деталізація нарахувань на зарплату працівників (hr_accrualFundDt)
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
)
select
	min(kpufa1.bookmark) "ID"
	,min(kpufa1.bookmark) "accrualFundID"
	,sum(kpuf_sm) "paySum"
	,case 
        when KpuF_SF > 0 then TO_CHAR(KpuF_SF) 
        else '' 
        end "dictFundSourceID"
	,'' "departmentID"
	,case 
        when KpuF_CdSch is not null and KpuF_CdSch > 0 then TO_CHAR(KpuF_CdSch) 
        else '' 
        end "accountID"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpufa1
join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 on x1.kpu_tn = kpufa1.kpuf_tn
join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = x1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
CROSS JOIN currentPeriod cp
where kpuf_cdfnd <> 0
	and kpuf_datup BETWEEN ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3) 
    AND cp.dateFrom - 1
group by kpuf_datup, kpuf_datrp, kpuf_tn, x1.kpu_rcd, kpuf_cdfnd, kpuf_prc, KpuF_SF, KpuF_CdSch
