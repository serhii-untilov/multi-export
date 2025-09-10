-- Трудова книжка (hr_employeeWorkbook)
WITH
-- Забезпечення унікальності РНОКПП {
employee AS (
    SELECT
        MAX(kpu_rcd) AS ID,
        KPU_CDNLP AS taxCode
    FROM KPUC1
    WHERE kpu_cdnlp IS NOT NULL
      AND LEN(KPU_CDNLP) > 5
    GROUP BY KPU_CDNLP
)
-- Забезпечення унікальності РНОКПП }
SELECT
    k1.kputd_rcd AS ID,
    x1.kpu_tn AS tabNum,
    CASE
        WHEN employee.ID IS NOT NULL
            THEN employee.ID
            ELSE k1.kpu_rcd
    END AS employeeID,
    k1.kpu_rcd AS employeeNumberID,
    -- employeepositionid,
    CONVERT(varchar(10), k1.KpuTD_DtV, 23) AS dateFrom,
    CASE
        WHEN k1.KpuTD_DtK <= '1876-12-31'
            THEN '9999-12-31'
            ELSE CONVERT(varchar(10), k1.KpuTD_DtK, 23)
    END AS dateTo,
    k1.KpuTD_AdrOrg AS workplace,
    -- dictprofessionid,
    k1.KpuTD_Dol AS workposition,
    k1.KpuTD_Com AS description,
    -- datetrialend,
    k1.KpuTD_Osn AS basedocument,
    -- appointorder,
    -- dismorder,
    k1.KpuTD_Osn AS appointreason
    -- dischargereason, positiontype, appointmentlevel, positioncategory, empworkplace, mtcount, organizationid, ismanualworkplace, isorgappoint, isorgdismiss, impemployeeid, impsourceid
FROM KpuTD1 k1
INNER JOIN kpuc1 c1 ON c1.kpu_rcd = k1.kpu_rcd
INNER JOIN kpux x1 ON x1.kpu_rcd = k1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
-- Забезпечення унікальності РНОКПП {
LEFT JOIN employee ON employee.taxCode = c1.KPU_CDNLP
-- Забезпечення унікальності РНОКПП }
WHERE x1.kpu_tn < 4000000000
  AND ((kpu_flg / 64) % 2) = 0
  AND (c1.kpu_flg & 2) = 0;
