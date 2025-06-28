-- Працівники (hr_employee)
SELECT
    TO_CHAR(x1.kpu_rcd) AS "ID",
    NVL(REGEXP_SUBSTR(c1.kpu_fio, '[^ ]+', 1, 1), '') AS "lastName",
    NVL(REGEXP_SUBSTR(c1.kpu_fio, '[^ ]+', 1, 2), '') AS "firstName",
    NVL(REGEXP_SUBSTR(c1.kpu_fio, '[^ ]+', 1, 3), '') AS "middleName",
    NVL(REGEXP_SUBSTR(c1.kpu_fio, '[^ ]+', 1, 1), '') || ' ' ||
    SUBSTR(NVL(REGEXP_SUBSTR(c1.kpu_fio, '[^ ]+', 1, 2), ''), 1, 1) || '. ' ||
    SUBSTR(NVL(REGEXP_SUBSTR(c1.kpu_fio, '[^ ]+', 1, 3), ''), 1, 1) || '.' AS "shortFIO",
    NVL(c1.kpu_fio, '') AS "fullFIO",
    NVL(c1.kpu_fioR, '') AS "genName",
    NVL(c1.kpu_fioD, '') AS "datName",
    NVL(c1.kpu_fioV, '') AS "accusativeName",
    NVL(c1.kpu_fio, '') AS "insName",
    NVL(TO_CHAR(x1.kpu_tn), '') AS "tabNum",
    'NEW' AS "state",
    CASE c1.kpu_cdpol WHEN 1 THEN 'W' WHEN 2 THEN 'M' ELSE 'null' END AS "sexType",
    CASE WHEN c1.kpu_dtroj <= TO_DATE('1876-12-31', 'yyyy-mm-dd') THEN 'null' ELSE TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD') END AS "birthDate",
    NVL(c1.kpu_cdnlp, '') AS "taxCode",
    NVL(Kpu_TelM, '') AS "phoneMobile",
    NVL(Kpu_TelS, '') AS "phoneWorking",
    NVL(Kpu_Tel, '') AS "phoneHome",
    NVL(Kpu_EMail, '') AS "email",
    NVL(c1.kpu_fio, '') AS "description",
    NVL(c1.kpu_fio, '') AS "locName" -- ,
    -- CASE WHEN c1.kpu_dtroj <= TO_DATE('1876-12-31', 'yyyy-mm-dd') THEN '' ELSE TO_CHAR(c1.kpu_dtroj, 'DD') END AS "dayBirthDate",
    -- CASE WHEN c1.kpu_dtroj <= TO_DATE('1876-12-31', 'yyyy-mm-dd') THEN '' ELSE TO_CHAR(c1.kpu_dtroj, 'MM') END AS "monthBirthDate",
    -- CASE WHEN c1.kpu_dtroj <= TO_DATE('1876-12-31', 'yyyy-mm-dd') THEN '' ELSE TO_CHAR(c1.kpu_dtroj, 'YYYY') END AS "yearBirthDate"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 c1 ON c1.Kpu_Rcd = x1.kpu_rcd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUK1 k1 ON k1.Kpu_Rcd = x1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
WHERE x1.kpu_tn < 4000000000
  AND MOD(TRUNC(Kpu_Flg / 64), 2) = 0
--  AND BITAND(c1.kpu_flg, 2) = 0
--  AND x1.kpu_tnosn = 0
