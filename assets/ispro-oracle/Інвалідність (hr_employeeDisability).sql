-- Інвалідність (hr_employeeDisability)
WITH 
-- Забезпечення унікальності РНОКПП {
employee AS (
	select max(kpu_rcd) ID, KPU_CDNLP taxCode
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 
	where kpu_cdnlp is not null and length(KPU_CDNLP) > 5
	GROUP BY KPU_CDNLP
)
-- Забезпечення унікальності РНОКПП }
SELECT
    TO_CHAR(i1.bookmark) AS "ID",
    TO_CHAR(c1.kpu_rcd) AS "employeeID",
    TO_CHAR(KpuInv_VIn) AS "disabilityID",
    SUBSTR(TO_CHAR(KpuInv_Grp), 1, 5) AS "disabilityGroup",
    CASE WHEN KpuInv_DtN <= DATE '1876-12-31' THEN NULL ELSE TO_CHAR(KpuInv_DtN, 'YYYY-MM-DD') END AS "dateFrom",
    CASE WHEN KpuInv_DtK <= DATE '1876-12-31' THEN '9999-12-31' ELSE TO_CHAR(KpuInv_DtK, 'YYYY-MM-DD') END AS "dateTo",
    SUBSTR(REPLACE(REPLACE(KpuInv_Nmr, CHR(13), ''), CHR(10), ''), 1, 20) AS "docNumber",
    SUBSTR(REPLACE(REPLACE(KpuInv_Sn, CHR(13), ''), CHR(10), ''), 1, 10) AS "docSeries",
    REPLACE(REPLACE(KpuInv_Who, CHR(13), ''), CHR(10), '') AS "docIssuer",
    CASE WHEN KpuInv_DtS <= DATE '1876-12-31' THEN NULL ELSE TO_CHAR(KpuInv_DtS, 'YYYY-MM-DD') END AS "dateIssue",
    REPLACE(REPLACE(KpuInv_TR, CHR(13), ''), CHR(10), '') AS "workReference",
    REPLACE(REPLACE(KpuInv_IPR, CHR(13), ''), CHR(10), '') AS "programDescription",
    SUBSTR(REPLACE(REPLACE(KpuInv_NmrIPR, CHR(13), ''), CHR(10), ''), 1, 10) AS "programNumber",
    CASE WHEN KpuInv_DtIPR <= DATE '1876-12-31' THEN NULL ELSE TO_CHAR(KpuInv_DtIPR, 'YYYY-MM-DD') END AS "programDate",
    REPLACE(REPLACE(KpuInv_WhoIPR, CHR(13), ''), CHR(10), '') AS "programIssuer",
    NULL AS "employeeDocID",
    (
        COALESCE(spr_nm, '') ||
        CASE WHEN spr_nm IS NOT NULL AND LENGTH(spr_nm) > 0 THEN ', ' ELSE '' END ||
        CASE WHEN KpuInv_Grp > 0 THEN TO_CHAR(KpuInv_Grp) || ' група' ELSE '' END ||
        CASE WHEN KpuInv_DtN > DATE '1876-12-31' AND (spr_nm IS NOT NULL OR KpuInv_Grp > 0) THEN ', ' END ||
        CASE WHEN (spr_nm IS NOT NULL OR KpuInv_Grp > 0) THEN ' з ' ELSE '' END ||
        CASE WHEN KpuInv_DtN > DATE '1876-12-31' THEN TO_CHAR(KpuInv_DtN, 'DD.MM.YYYY') ELSE '' END ||
        CASE WHEN KpuInv_DtK > DATE '1876-12-31' AND (spr_nm IS NOT NULL OR KpuInv_Grp > 0 OR KpuInv_DtN > DATE '1876-12-31') THEN ' по ' ELSE '' END ||
        CASE WHEN KpuInv_DtK > DATE '1876-12-31' THEN TO_CHAR(KpuInv_DtK, 'DD.MM.YYYY') ELSE '' END
    ) AS "description"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuinv i1
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 ON c1.kpu_rcd = i1.kpu_rcd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 ON x1.kpu_rcd = c1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
-- Забезпечення унікальності РНОКПП {
LEFT JOIN employee ON employee.taxCode = c1.KPU_CDNLP
-- Забезпечення унікальності РНОКПП }
LEFT JOIN /*SYS_SCHEMA*/ISPRO_8_PROD_SYS.sspr ON sprspr_cd = 681037 AND spr_cdlng = 2 AND spr_cd = KpuInv_VIn
WHERE BITAND(c1.kpu_flg, 2) = 0
AND x1.kpu_tn < 4000000000
  AND MOD(TRUNC(Kpu_Flg / 64), 2) = 0
--  AND BITAND(c1.kpu_flg, 2) = 0
--  AND x1.kpu_tnosn = 0
-- Забезпечення унікальності РНОКПП {
  AND (employee.ID IS NULL OR c1.kpu_rcd = employee.ID)
-- Забезпечення унікальності РНОКПП }

  
