-- Документи (hr_employeeDocs)
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
  TO_CHAR(d1.bookmark) AS "ID",
  TO_CHAR(d1.kpu_rcd) AS "employeeID",
  TO_CHAR(d1.kpupsp_typdoc) AS "dictDocKindID",
  d1.kpupsp_ser AS "docSeries",
  d1.kpupsp_nmr AS "docNumber",
  d1.kpupsp_who AS "docIssued",
  TO_CHAR(CASE WHEN d1.kpupsp_dat <= DATE '1876-12-31' THEN NULL ELSE d1.kpupsp_dat END, 'YYYY-MM-DD') AS "docIssuedDate",
  TO_CHAR(CASE WHEN d1.kpupsp_term <= DATE '1876-12-31' THEN NULL ELSE d1.kpupsp_term END, 'YYYY-MM-DD') AS "docValidUntil",
  TO_CHAR(KpuPsp_Add + 1) AS "state",
  d1.kpupsp_com AS "comment",
  s1.spr_nm ||
    CASE WHEN LENGTH(s1.spr_nm) > 0 AND LENGTH(d1.kpupsp_ser) > 0 THEN ', ' ELSE '' END ||
    d1.kpupsp_ser ||
    CASE WHEN LENGTH(d1.kpupsp_nmr) > 0 THEN ' № ' ELSE '' END || d1.kpupsp_nmr ||
    CASE WHEN LENGTH(s1.spr_nm || d1.kpupsp_ser || d1.kpupsp_nmr) > 0 AND d1.kpupsp_dat > DATE '1876-12-31'
         THEN ', ' ELSE '' END ||
    CASE WHEN d1.kpupsp_dat <= DATE '1876-12-31' THEN '' ELSE TO_CHAR(d1.kpupsp_dat, 'DD.MM.YYYY') END AS "description"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.KpuPsp1 d1
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 ON c1.kpu_rcd = d1.kpu_rcd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 ON x1.kpu_rcd = d1.kpu_rcd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 pdr1 ON pdr1.kpu_rcd = c1.kpu_rcd
  AND pdr1.bookmark = (
    SELECT MAX(pdr2.bookmark)
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 pdr2
    WHERE pdr2.kpu_rcd = c1.kpu_rcd
      AND pdr2.kpuprkz_dtv = (
        SELECT MAX(pdr3.kpuprkz_dtv)
        FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 pdr3
        WHERE pdr3.kpu_rcd = c1.kpu_rcd
          AND pdr3.kpuprkz_dtv <= SYSDATE
      )
  )
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr s1 ON s1.sprspr_cd = 513 AND s1.spr_cd = d1.kpupsp_typDoc
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
WHERE BITAND(c1.kpu_flg, 2) = 0 AND (LENGTH(d1.kpupsp_ser) > 0 OR LENGTH(d1.kpupsp_nmr) > 0)
AND x1.kpu_tn < 4000000000
  AND MOD(TRUNC(Kpu_Flg / 64), 2) = 0
--  AND BITAND(c1.kpu_flg, 2) = 0
--  AND x1.kpu_tnosn = 0
-- Забезпечення унікальності РНОКПП {
  AND (employee.ID IS NULL OR c1.kpu_rcd = employee.ID)
-- Забезпечення унікальності РНОКПП }

