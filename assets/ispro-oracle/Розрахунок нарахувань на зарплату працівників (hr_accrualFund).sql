-- Нарахування на зарплату працівників (hr_accrualFund)
select
	min(f1.bookmark) "ID"	
	,TO_CHAR(f1.kpuf_datup, 'YYYY-MM-DD') "periodCalc"
	,TO_CHAR(f1.kpuf_datrp, 'YYYY-MM-DD') "periodSalary"
	,f1.kpuf_tn "tabNum"
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
where f1.kpuf_cdfnd <> 0
	and f1.kpuf_datup between ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
		and ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1)
group by kpuf_datup, kpuf_datrp, kpuf_tn, x1.kpu_rcd, kpuf_cdfnd, kpuf_prc, KpuF_SF, KpuF_CdSch
