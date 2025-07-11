-- Нарахування на зарплату працівників (hr_accrualFund)
-- Забезпечення унікальності РНОКПП {
WITH 
employee AS (
	SELECT /*+ MATERIALIZE */ 
	max(kpu_rcd) ID, KPU_CDNLP taxCode
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 
	where kpu_cdnlp is not null and length(KPU_CDNLP) > 5
	GROUP BY KPU_CDNLP
)
-- Забезпечення унікальності РНОКПП }
select
	min(f1.bookmark) "ID"	
	,TO_CHAR(f1.kpuf_datup, 'YYYY-MM-DD') "periodCalc"
	,TO_CHAR(f1.kpuf_datrp, 'YYYY-MM-DD') "periodSalary"
	,f1.kpuf_tn "tabNum"
	,CASE WHEN employee.ID IS NOT NULL THEN employee.ID ELSE x1.kpu_rcd END "employeeID"	
	,x1.kpu_rcd "employeeNumberID"	
	,f1.kpuf_cdfnd "payFundID"
	,sum(f1.kpuf_smsrc) "sourceSum"
	-- 04-11-2020,cast(sum(case when (kpuf_prz & 128) = 0 then kpuf_smclc else 0 end) as varchar) baseSum
	,sum(f1.kpuf_smclc) "baseSum" -- 04-11-2020
	,f1.kpuf_prc "rate"
	,sum(f1.kpuf_sm) "paySum"	
	,sum(case when BITAND(f1.kpuf_prz, 128) <> 0 then kpuf_smclc else 0 end) "addMinSum"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpufa1 f1
join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 on x1.kpu_tn = f1.kpuf_tn
join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = x1.kpu_rcd
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
where f1.kpuf_cdfnd <> 0
	and f1.kpuf_datup between ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
		and ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1)
group by kpuf_datup, kpuf_datrp, kpuf_tn, x1.kpu_rcd, 
	CASE WHEN employee.ID IS NOT NULL THEN employee.ID ELSE x1.kpu_rcd END, 
	kpuf_cdfnd, kpuf_prc, KpuF_SF, KpuF_CdSch
