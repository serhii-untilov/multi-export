-- Сальдо по місяцям (hr_accrualBalance)
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
SELECT
    s1.bookmark "ID",
    x1.kpu_rcd "employeeID",
    x1.kpu_rcd "employeeNumberID",
    TO_CHAR(s1.kpurl_datUp, 'YYYY-MM-DD') "periodCalc",
    CASE
        WHEN s1.kpurl_sf = 0 THEN ''
        ELSE TO_CHAR(s1.kpurl_sf)
    END "dictFundSourceID",
    s1.kpurl_sin / 100 "sumFrom",
    s1.kpurl_nch / 100 "sumPlus",
    (s1.kpurl_udr - COALESCE(t1.kpurl_sm, 0)) / 100 "sumMinus",
    COALESCE(t1.kpurl_sm, 0) / 100 "sumPay",
    s1.kpurl_sout / 100 "sumTo"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpurlonus s1
INNER JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 ON x1.kpu_tn = s1.kpu_tn
INNER JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 ON c1.kpu_rcd = x1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
CROSS JOIN currentPeriod cp
LEFT JOIN (
    SELECT
        r1.kpu_tn,
        r1.kpurl_datup,
        0 kpurl_sf,
        SUM(r1.kpurl_sm) kpurl_sm
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpurlo1 r1
    INNER JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x2 ON x2.kpu_tn = r1.kpu_tn
    INNER JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c2 ON c2.kpu_rcd = x2.kpu_rcd
    /*SYSSTE_BEGIN*/
    JOIN (
        SELECT MAX(sysste_rcd) AS sysste_rcd
        FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
        WHERE sysste_cd = /*SYSSTE_CD*/'1500'
    ) ste1 ON ste1.sysste_rcd = c2.kpuc_se
    /*SYSSTE_END*/
    INNER JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.payvo1 v1 ON v1.vo_cd = r1.kpurl_cdvo
    CROSS JOIN currentPeriod cp
    WHERE r1.KpuRl_CdVo <> 0
      AND r1.KpuRl_DatUp >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
      AND BITAND(r1.KpuRl_Prz, 65536) = 0
      AND (r1.KpuRl_DatUp < cp.dateFrom OR BITAND(KpuRl_Prz, 1) = 0)
      AND v1.vo_grp = 130
    GROUP BY r1.kpu_tn, r1.kpurl_datup

    UNION ALL

    SELECT
        r1.kpu_tn,
        r1.kpurl_datup,
        r1.kpurl_sf,
        SUM(r1.kpurl_sm) kpurl_sm
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpurlo1 r1
    INNER JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x2 ON x2.kpu_tn = r1.kpu_tn
    INNER JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c2 ON c2.kpu_rcd = x2.kpu_rcd
    /*SYSSTE_BEGIN*/
    JOIN (
        SELECT MAX(sysste_rcd) AS sysste_rcd
        FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
        WHERE sysste_cd = /*SYSSTE_CD*/'1500'
    ) ste1 ON ste1.sysste_rcd = c2.kpuc_se
    /*SYSSTE_END*/
    INNER JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.payvo1 v1 ON v1.vo_cd = r1.kpurl_cdvo
    CROSS JOIN currentPeriod cp
    WHERE r1.KpuRl_CdVo <> 0
      AND r1.kpurl_sf <> 0
      AND r1.KpuRl_DatUp >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
      AND BITAND(r1.KpuRl_Prz, 65536) = 0
      AND (r1.KpuRl_DatUp < cp.dateFrom OR BITAND(KpuRl_Prz, 1) = 0)
      AND v1.vo_grp = 130
    GROUP BY r1.kpu_tn, r1.kpurl_datup, r1.kpurl_sf
) t1
ON t1.kpu_tn = s1.kpu_tn
AND t1.kpurl_datup = s1.kpurl_datup
AND t1.kpurl_sf = s1.kpurl_sf
WHERE s1.kpurl_datup BETWEEN ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
    AND cp.dateFrom - 1
