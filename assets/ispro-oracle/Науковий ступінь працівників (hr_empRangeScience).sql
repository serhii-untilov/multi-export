-- Науковий ступінь працівників (hr_empRangeScience)
SELECT
    KpuNau_Rcd AS "ID",
    TO_CHAR(n1.kpu_rcd) AS "employeeID",
    TO_CHAR(n1.kpu_rcd) AS "employeeNumberID",
    TO_CHAR(x1.kpu_tn) AS "tabNum",
    c1.kpu_cdnlp AS "taxCode",
    c1.kpu_fio AS "fullFIO",
    CASE
        WHEN c1.kpu_dtroj <= DATE '1876-12-31' THEN ''
        ELSE TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD')
    END AS "birthDate",
    KpuNau_CdOtr AS "dictBranchScienceID",
    KpuNau_CdNS AS "dictDegreeID",
    s1.spr_nm AS "dictDegreeName",
    KpuNau_CdSp AS "dictSpecialtyID",
    KpuNau_CdSp AS "dictSpecialtyCode",
    CASE
        WHEN s2.spr_nm IS NOT NULL THEN s2.spr_nm
        ELSE KpuNau_SpNm
    END AS "dictSpecialtyName",
    KpuNau_Dsr AS "educationName",
    KpuNau_NmrD AS "docNumber",
    TO_CHAR(KpuNau_DtVD, 'YYYY-MM-DD') AS "docDate",
    KpuNau_MZ AS "comment",
    KpuNau_YPr AS "yearOf",
    KpuNau_CdMZ AS "educationOrgID"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.KpuNau1 n1
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 c1 ON c1.Kpu_Rcd = n1.Kpu_Rcd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 ON x1.kpu_rcd = n1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr s1 ON s1.sprspr_cd = 680964 AND s1.Spr_Cd = n1.KpuNau_CdNS
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr s2 ON s2.sprspr_cd = 681003 AND s2.spr_cd = KpuNau_CdSp
WHERE n1.KpuNau_CdNS > 0
UNION ALL
SELECT
    KpuNau_Rcd AS "ID",
    TO_CHAR(n1.kpu_rcd) AS "employeeID",
    TO_CHAR(n1.kpu_rcd) AS "employeeNumberID",
    TO_CHAR(x1.kpu_tn) AS "tabNum",
    c1.kpu_cdnlp AS "taxCode",
    c1.kpu_fio AS "fullFIO",
    CASE
        WHEN c1.kpu_dtroj <= DATE '1876-12-31' THEN ''
        ELSE TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD')
    END AS "birthDate",
    KpuNau_CdOtr AS "dictBranchScienceID",
    KpuNau_CdUZ + 1000 AS "dictDegreeID",
    s3.spr_nm AS "dictDegreeName",
    KpuNau_CdSp AS "dictSpecialtyID",
    KpuNau_CdSp AS "dictSpecialtyCode",
    CASE
        WHEN s2.spr_nm IS NOT NULL THEN s2.spr_nm
        ELSE KpuNau_SpNm
    END AS "dictSpecialtyName",
    KpuNau_Dsr AS "educationName",
    KpuNau_NmrD AS "docNumber",
    TO_CHAR(KpuNau_DtVD, 'YYYY-MM-DD') AS "docDate",
    KpuNau_MZ AS "comment",
    KpuNau_YPr AS "yearOf",
    KpuNau_CdMZ AS "educationOrgID"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.KpuNau1 n1
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 c1 ON c1.Kpu_Rcd = n1.Kpu_Rcd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 ON x1.kpu_rcd = n1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr s2 ON s2.sprspr_cd = 681003 AND s2.spr_cd = KpuNau_CdSp
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr s3 ON s3.sprspr_cd = 680981 AND s3.spr_cd = n1.KpuNau_CdUZ
WHERE n1.KpuNau_CdUZ > 0
