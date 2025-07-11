-- Дата початку перерахунку зарплати працівників (hr_payCalcDateFrom)
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
)
-- Забезпечення унікальності РНОКПП {
,employee AS (
	select max(kpu_rcd) ID, KPU_CDNLP taxCode
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 
	where kpu_cdnlp is not null and length(KPU_CDNLP) > 5
	GROUP BY KPU_CDNLP
)
-- Забезпечення унікальності РНОКПП }
SELECT 
    x1.kpu_rcd AS "ID",
    CASE WHEN employee.ID IS NOT NULL THEN employee.ID ELSE x1.kpu_rcd end AS "employeeID",
    x1.kpu_rcd AS "employeeNumberID",
    x1.kpu_tn AS "tabNum",
    TO_CHAR(cp.dateFrom, 'YYYY-MM-DD') AS "periodCalc",
    TO_CHAR(x1.kpu_datreclc, 'YYYY-MM-DD') AS "periodSalary"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1
INNER JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 ON c1.kpu_rcd = x1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
CROSS JOIN currentPeriod cp
-- Забезпечення унікальності РНОКПП {
LEFT JOIN employee ON employee.taxCode = c1.KPU_CDNLP
-- Забезпечення унікальності РНОКПП }
WHERE x1.kpu_datreclc > TO_DATE('1876-12-31', 'YYYY-MM-DD')
and x1.kpu_datreclc < cp.dateFrom
--union all
--select 
--	cast(x1.kpu_rcd as varchar) ID	
--	,cast(x1.kpu_rcd as varchar) employeeNumberID	
--	,cast(kpu_tn as varchar) tabNum
--	,cast(cast(KpuArcDat_Per as date) as varchar) periodCalc	
--	,cast(cast(KpuArcDat_Dat as date) as varchar) periodSalary	
--from KpuArDtRClc1 a1
--inner join kpux x1 on x1.kpu_rcd = a1.kpu_rcd
--where KpuArcDat_Per >= @dateFrom