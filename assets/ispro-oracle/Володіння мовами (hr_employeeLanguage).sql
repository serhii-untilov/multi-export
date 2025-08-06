-- Володіння мовами (hr_employeeLanguage)
SELECT 
    l1.KpuLng_Rcd AS "ID",
    c1.kpu_rcd AS "employeeID",
    c1.kpu_cdnlp AS "taxCode",
    c1.kpu_fio AS "fullFIO",
    TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD') AS "birthDate",
    TO_CHAR(l1.KpuLng_Cd) AS "dictLanguageID",
    TO_CHAR(l1.KpuLng_Cd) AS "dictLanguageCode",
    TO_CHAR(s1.spr_nm) AS "dictLanguageName",
    TO_CHAR(l1.KpuLng_StV) AS "dictLanguageLevelID",
    TO_CHAR(l1.KpuLng_StV) AS "dictLanguageLevelCode",
    s2.spr_nm AS "dictLanguageLevelName",
    '' AS "employeeDocID",
    l1.KpuLng_DocNum AS "docNumber",
    '' AS "docSeries",
    '' AS "docIssuer",
    CASE 
        WHEN l1.KpuLng_DocDate <= TO_DATE('1876-12-31', 'YYYY-MM-DD') THEN '' 
        ELSE TO_CHAR(l1.KpuLng_DocDate, 'YYYY-MM-DD') 
    END AS "dateIssue"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.KpuLng1 l1
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 ON c1.kpu_rcd = l1.kpu_rcd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr s1 ON s1.sprspr_cd = 680965 AND s1.spr_cd = l1.KpuLng_Cd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 ON x1.kpu_rcd = c1.kpu_rcd AND x1.kpu_tnosn = 0
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr s2 ON s2.sprspr_cd = 680966 AND s2.spr_cd = l1.KpuLng_StV
