-- Призначення працівників (hr_employeePosition)
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
    CASE WHEN employee.ID IS NOT NULL THEN employee.ID ELSE p1.kpu_rcd end "employeeID",
    c1.kpu_cdnlp "taxCode",
    x1.kpu_tn "tabNum",
    p1.kpu_rcd "employeeNumberID",
    CASE
        WHEN KpuPrkz_DtV <= TO_DATE('1876-12-31', 'YYYY-MM-DD') AND c1.kpu_dtpst <= TO_DATE('1876-12-31', 'YYYY-MM-DD')
            THEN '1970-01-01'
        WHEN KpuPrkz_DtV <= TO_DATE('1876-12-31', 'YYYY-MM-DD')
            THEN TO_CHAR(c1.kpu_dtpst, 'YYYY-MM-DD')
        WHEN c1.kpu_dtpst <= TO_DATE('1876-12-31', 'YYYY-MM-DD')
            THEN TO_CHAR(KpuPrkz_DtV, 'YYYY-MM-DD')
        WHEN p1.kpuprkz_dtv < c1.kpu_dtpst THEN TO_CHAR(c1.kpu_dtpst, 'YYYY-MM-DD')
        ELSE TO_CHAR(p1.kpuprkz_dtv, 'YYYY-MM-DD')
    END "dateFrom",
    TO_CHAR(COALESCE((
    	SELECT min(p2.kpuprkz_dtv) - 1
    	FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 p2
    	WHERE p2.kpu_rcd = p1.kpu_rcd AND p2.kpuprkz_dtv > p1.kpuprkz_dtv
    	), TO_DATE('9999-12-31', 'YYYY-MM-DD')), 'YYYY-MM-DD') "dateTo",
    p1.KpuPrkz_PdRcd "departmentID",
    CASE
        WHEN sprdol.sprd_cd IS NULL THEN NULL
        ELSE p1.kpuprkz_pdrcd * 10000 + p1.kpuprkz_dol
    END positionID,
    CASE
        WHEN p1.KpuPrkz_DtNzE <= TO_DATE('1876-12-31', 'YYYY-MM-DD') THEN ''
        ELSE TO_CHAR(p1.KpuPrkz_DtNzE, 'YYYY-MM-DD')
    END "changeDateTo",
    p1.KpuPrkz_RejWr "workScheduleID",
    CASE
        WHEN ASCII(spst.SPR_NMSHORT) = 7 THEN '2'
        WHEN ASCII(spst.SPR_NMSHORT) = 4 THEN '4'
        ELSE '1'
    END "workerType",
    p1.KpuPrkz_QtStv "mtCount",
    TRIM(TO_CHAR(x1.kpu_tn) || ' ' || c1.kpu_fio || ' ' || COALESCE(sprdol.sprd_nmim, ' ')) "description",
    p1.KpuPrkz_Rn "dictRankID",
    p1.KpuPrkz_Kat "dictStaffCatID",
    p1.KpuPrkz_SysOp "payElID",
    p1.KpuPrkz_Okl / POWER(10, p1.KpuPrkz_KfcMT) "accrualSum",
    CASE
        WHEN p1.KpuPrkz_IdxBsd <= TO_DATE('1876-12-31', 'YYYY-MM-DD') THEN ''
        ELSE TO_CHAR(p1.KpuPrkz_IdxBsd, 'YYYY-MM-DD')
    END "raiseSalary",
    CASE
        WHEN MOD(TRUNC(p1.KpuPrkz_Prz), 2) <> 0 THEN '1'
        ELSE '0'
    END AS "isIndex",
    '1' "isActive",
    CASE
        WHEN x1.kpu_tnosn <> 0 THEN '2'
        WHEN ASCII(spst.SPR_NMSHORT) IN (2, 6) THEN '3'
        WHEN ASCII(spst.SPR_NMSHORT) = 3 THEN '4'
        ELSE '1'
    END "workPlace",
    CASE
        WHEN p1.KpuPrkz_SF = 0 THEN ''
        ELSE TO_CHAR(p1.KpuPrkz_SF)
    END "dictFundSourceID",
    CASE
        WHEN p1.KpuPrkz_Rn <> 0 THEN '25'
        WHEN p1.KpuPrkz_CdSZ = 0 THEN '1'
        ELSE TO_CHAR(p1.KpuPrkz_CdSZ)
    END "dictCategoryECBID",
    p1.KpuPrkz_Sch "accountID",
    CASE
        WHEN p1.kpuprkz_dol = 0 THEN ''
        ELSE TO_CHAR(p1.kpuprkz_dol)
    END "dictPositionID",
    CASE
        WHEN p1.kpuprkz_rcd = 0 THEN ''
        ELSE TO_CHAR(p1.kpuprkz_rcd)
    END "orderID",
    p1.kpuprkz_cd "orderNumber",
    CASE
        WHEN p1.kpuprkz_dt <= TO_DATE('1876-12-31', 'YYYY-MM-DD') THEN ''
        ELSE TO_CHAR(p1.kpuprkz_dt, 'YYYY-MM-DD')
    END "orderDate",
    CASE
        WHEN p1.KpuPrkz_RcS = 0 THEN ''
        ELSE TO_CHAR(p1.KpuPrkz_RcS)
    END "staffingTableID",
    CASE
        WHEN p1.KpuPrkz_Raz = 0 THEN ''
        ELSE TO_CHAR(p1.KpuPrkz_Raz)
    END "dictTarifCoeffID"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 p1
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUX x1 ON x1.Kpu_Rcd = p1.Kpu_Rcd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 c1 ON c1.Kpu_Rcd = p1.kpu_rcd
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
