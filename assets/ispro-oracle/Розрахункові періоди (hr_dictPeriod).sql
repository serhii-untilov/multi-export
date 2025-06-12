-- Розрахункові періоди (hr_dictPeriod)
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
periods AS (
    SELECT 
        p.bookmark AS "ID",
        p.PerBas_Period AS dateFrom,
        LAST_DAY(p.PerBas_Period) AS dateTo,
        '1' AS isClosed,
        '0' AS isCurrent
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.PerBas p
    /*SYSSTE_BEGIN*/
    JOIN (
        SELECT MAX(sysste_rcd) AS sysste_rcd
        FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
        WHERE sysste_cd = /*SYSSTE_CD*/'1500'
    ) ste1 ON ste1.sysste_rcd = p.PerBas_CdSte
    /*SYSSTE_END*/
    CROSS JOIN currentPeriod cp
    WHERE p.perBas_cdBpr = 2
      AND p.perBas_period < cp.dateFrom
      AND p.perBas_period >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
),
new_period AS (
    SELECT
        (SELECT NVL(MAX(bookmark), 0) + 1 FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.PerBas) AS "ID",
        cp.dateFrom AS dateFrom,
        LAST_DAY(cp.dateFrom) AS dateTo,
        '0' AS isClosed,
        '1' AS isCurrent
    FROM currentPeriod cp
)
SELECT 
    "ID",
    TO_CHAR(dateFrom, 'YYYY-MM-DD') AS "dateFrom",
    TO_CHAR(dateTo, 'YYYY-MM-DD') AS "dateTo",
    isClosed "isClosed",
    isCurrent "isCurrent"
FROM periods

UNION ALL

SELECT 
    "ID",
    TO_CHAR(dateFrom, 'YYYY-MM-DD') AS "dateFrom",
    TO_CHAR(dateTo, 'YYYY-MM-DD') AS "dateTo",
    isClosed "isClosed",
    isCurrent "isCurrent"
FROM new_period

