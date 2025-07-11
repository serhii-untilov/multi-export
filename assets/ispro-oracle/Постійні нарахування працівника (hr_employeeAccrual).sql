-- Постійні нарахування працівника (hr_employeeAccrual)
-- Забезпечення унікальності РНОКПП {
WITH employee AS (
	select max(kpu_rcd) ID, KPU_CDNLP taxCode
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 
	where kpu_cdnlp is not null and length(KPU_CDNLP) > 5
	GROUP BY KPU_CDNLP
)
-- Забезпечення унікальності РНОКПП }
select
	n1.KpuNch_Id "ID"
	,x1.kpu_tn "tabNum"
	,CASE WHEN employee.ID IS NOT NULL THEN employee.ID ELSE n1.kpu_rcd END "employeeID"
	,n1.kpu_rcd "employeeNumberID"
	,n1.kpunch_cd "payElID"
	,case
		when n1.kpuNch_datn <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then ''
		else TO_CHAR(n1.kpuNch_datn, 'YYYY-MM-DD')
		end "dateFrom"
	,case
		when n1.kpuNch_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '9999-12-31'
		else TO_CHAR(n1.kpuNch_datk, 'YYYY-MM-DD')
		end "dateTo"
	,case
		when vo_grp = 1 then TO_CHAR(n1.KpuNch_Sm / POWER(10, n1.KpuNch_MT))
		when BITAND(KpuNch_Prz, 1) <> 0 then ''
		else TO_CHAR(n1.KpuNch_Sm / POWER(10, n1.KpuNch_MT))
		end "accrualSum"
	,case
		when vo_grp = 1 then ''
		when BITAND(KpuNch_Prz, 1) = 0 then ''
		else TO_CHAR(n1.KpuNch_Sm / POWER(10, n1.KpuNch_MT))
		end "accrualRate"
	,n1.KpuNch_CdPr "orderNumber"
	,case
		when n1.KpuNch_DtPr <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then ''
		else TO_CHAR(n1.KpuNch_DtPr, 'YYYY-MM-DD')
		end "orderDatefrom"
	,c1.kpu_cdnlp "taxCode"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpunch1 n1
join /*FIRM_SCHEMA*/ISPRO_8_PROD.payvo1 v1 on v1.vo_cd = n1.kpunch_cd
join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = n1.kpu_rcd
join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 on x1.kpu_rcd = n1.kpu_rcd
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
where n1.kpuNch_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD')
	or n1.kpuNch_datk >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)