-- Фізичні особи (hr_people)
/*SYSSTE_BEGIN*/
WITH 
ste1 AS (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
)
/*SYSSTE_END*/
SELECT
    TO_CHAR(x1.kpu_rcd) AS "ID",
    NVL(REGEXP_SUBSTR(c1.kpu_fio, '[^ ]+', 1, 1), '') AS "lastName",
    NVL(REGEXP_SUBSTR(c1.kpu_fio, '[^ ]+', 1, 2), '') AS "firstName",
    NVL(REGEXP_SUBSTR(c1.kpu_fio, '[^ ]+', 1, 3), '') AS "middleName",
    NVL(REGEXP_SUBSTR(c1.kpu_fio, '[^ ]+', 1, 1), '') || ' ' ||
    SUBSTR(NVL(REGEXP_SUBSTR(c1.kpu_fio, '[^ ]+', 1, 2), ''), 1, 1) || '. ' ||
    SUBSTR(NVL(REGEXP_SUBSTR(c1.kpu_fio, '[^ ]+', 1, 3), ''), 1, 1) || '.' AS "shortFIO",
    NVL(c1.kpu_fio, '') AS "fullFIO",
    CASE c1.kpu_cdpol WHEN 1 THEN 'W' WHEN 2 THEN 'M' ELSE '' END AS "sexType",
    CASE 
        WHEN c1.kpu_dtroj <= TO_DATE('1876-12-31', 'yyyy-mm-dd') THEN '' 
        ELSE TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD') 
    END AS "birthDate",
    NVL(c1.kpu_cdnlp, '') AS "taxCode",
    NVL(c1.Kpu_TelM, '') AS "phoneMobile",
    NVL(c1.Kpu_TelS, '') AS "phoneWorking",
    NVL(c1.Kpu_Tel, '') AS "phoneHome",
    NVL(c1.Kpu_EMail, '') AS "email",
    NVL(c1.kpu_fio, '') AS "description"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 c1 ON c1.kpu_rcd = x1.kpu_rcd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUK1 k1 ON k1.kpu_rcd = x1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
WHERE x1.kpu_tn < 4000000000
  AND MOD(TRUNC(kpu_flg / 64), 2) = 0
--  AND BITAND(c1.kpu_flg, 2) = 0
--  AND x1.kpu_tnosn = 0
