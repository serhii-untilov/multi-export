-- Працівники (Особові рахунки) (hr_employeeNumber)
WITH 
/*SYSSTE_BEGIN*/
ste1 AS (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
),
/*SYSSTE_END*/
-- for personalAccount {
pa1 AS (
    SELECT 
        kpu_rcd, 
        MAX(kpuudr_id) AS kpuudr_id
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuudr1
    WHERE LENGTH(NVL(kpuudr_ls, '')) > 0
      AND kpuudr_cd IN (
          SELECT vo_cd 
          FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.payvo1 
          WHERE vo_met IN (60, 61, 35)
      )
    GROUP BY kpu_rcd
)
-- for personalAccount }
SELECT
    x1.kpu_rcd AS "ID",
    x1.kpu_rcd AS "employeeID",
    NVL(c1.kpu_cdnlp, '') AS "taxCode",
    x1.kpu_tn AS "tabNum",
    CASE 
        WHEN c1.kpu_dtpst IS NOT NULL THEN TO_CHAR(c1.kpu_dtpst, 'YYYY-MM-DD') 
        ELSE NULL 
    END AS "dateFrom",
    CASE 
        WHEN c1.kpu_dtuvl <= TO_DATE('1876-12-31', 'YYYY-MM-DD') THEN '9999-12-31' 
        ELSE TO_CHAR(c1.kpu_dtuvl, 'YYYY-MM-DD') 
    END AS "dateTo",
    c1.kpu_fio || '[' || TO_CHAR(x1.kpu_tn) || ']' AS "description",
    '' AS "payOutID",
    t4.kpuudr_ls AS "personalAccount",
    TO_CHAR(c1.kpu_dtpst, 'YYYY-MM-DD') AS "appointmentDate",
    '' AS "appointmentOrderDate",
    '' AS "appointmentOrderNumber",
    CASE 
        WHEN c1.kpu_dtroj <= TO_DATE('1876-12-31', 'YYYY-MM-DD') THEN '' 
        ELSE TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD') 
    END AS "birthDate"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 c1 ON c1.kpu_rcd = x1.kpu_rcd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUK1 k1 ON k1.kpu_rcd = x1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
-- for personalAccount {
LEFT JOIN pa1 ON pa1.kpu_rcd = x1.kpu_rcd
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuudr1 t4 ON t4.kpuudr_id = pa1.kpuudr_id
-- for personalAccount }
WHERE 
    x1.kpu_tn < 4000000000
    AND MOD(TRUNC(kpu_flg / 64), 2) = 0
--  AND BITAND(c1.kpu_flg, 2) = 0
--  AND x1.kpu_tnosn = 0
