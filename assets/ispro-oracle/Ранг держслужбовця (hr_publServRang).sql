-- Ранг держслужбовця (hr_publServRang)
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
    p1.bookmark "ID",
    CASE WHEN employee.ID IS NOT NULL THEN employee.ID ELSE p1.kpu_rcd END "employeeID",
    c1.kpu_cdnlp "taxCode",
    x1.kpu_tn "tabNum",
    p1.kpu_rcd "employeeNumberID",
    CASE 
        WHEN p1.KpuPrkz_DtV <= TO_DATE('1876-12-31', 'YYYY-MM-DD') AND c1.kpu_dtpst <= TO_DATE('1876-12-31', 'YYYY-MM-DD') 
            THEN '1970-01-01'
        WHEN p1.KpuPrkz_DtV <= TO_DATE('1876-12-31', 'YYYY-MM-DD') 
            THEN TO_CHAR(c1.kpu_dtpst, 'YYYY-MM-DD')
        WHEN c1.kpu_dtpst <= TO_DATE('1876-12-31', 'YYYY-MM-DD') 
            THEN TO_CHAR(p1.KpuPrkz_DtV, 'YYYY-MM-DD')
        WHEN p1.kpuprkz_dtv < c1.kpu_dtpst THEN TO_CHAR(c1.kpu_dtpst, 'YYYY-MM-DD') 
        ELSE TO_CHAR(p1.kpuprkz_dtv, 'YYYY-MM-DD')
    END "dateFrom",
    TO_CHAR(COALESCE((
    	SELECT min(p2.kpuprkz_dtv) - 1
    	FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 p2 
    	WHERE p2.kpu_rcd = p1.kpu_rcd AND p2.kpuprkz_dtv > p1.kpuprkz_dtv
    	), TO_DATE('9999-12-31', 'YYYY-MM-DD')), 'YYYY-MM-DD') "dateTo",
    p1.KpuPrkz_Rn "dictRankID",
    CASE 
        WHEN p1.kpuprkz_rcd = 0 THEN '' 
        ELSE TO_CHAR(p1.kpuprkz_rcd) 
    END "orderID",
    p1.kpuprkz_cd "orderNumber",
    CASE 
        WHEN p1.kpuprkz_dt <= TO_DATE('1876-12-31', 'YYYY-MM-DD') THEN '' 
        ELSE TO_CHAR(p1.kpuprkz_dt, 'YYYY-MM-DD') 
    END "orderDate"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 p1
INNER JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUX x1 ON x1.Kpu_Rcd = p1.Kpu_Rcd
INNER JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 c1 ON c1.Kpu_Rcd = p1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.sprdol ON sprd_cd = p1.kpuprkz_dol
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr spst ON spst.sprspr_cd = 547 AND spst.spr_cd = p1.kpuprkz_spst
-- Забезпечення унікальності РНОКПП {
LEFT JOIN employee ON employee.taxCode = c1.KPU_CDNLP
-- Забезпечення унікальності РНОКПП }
WHERE 
    x1.kpu_tn < 4000000000
    AND MOD(TRUNC(kpu_flg / 64), 2) = 0
