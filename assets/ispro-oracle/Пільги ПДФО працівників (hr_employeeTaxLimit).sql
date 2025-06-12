-- Пільги ПДФО працівників (hr_employeeTaxLimit)
select 
	l1.bookmark "ID"
	,x1.kpu_tn "tabNum"
	,l1.kpu_rcd "employeeNumberID"
	,TO_CHAR(kpupdxlg_dtn, 'YYYY-MM-DD') "dateFrom"
	,case 
		when kpupdxlg_dtk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '9999-12-31' 
		else TO_CHAR(kpupdxlg_dtk, 'YYYY-MM-DD') 
		end "dateTo"
	,kpupdxlg_cd "taxLimitID"
	,case when kpupdxlg_cd = 2 then '3'
		when kpupdxlg_cd = 3 then '4'
		when kpupdxlg_cd = 5 then '5' 
		when kpupdxlg_cd = 6 then '2'
		when kpupdxlg_cd = 30 then '1'
		when kpupdxlg_cd = 50 then '1'
		when kpupdxlg_cd = 51 then '2'
		else '0' 
		end "amountChild"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.KpuPdxOLg01 l1
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = l1.kpu_rcd
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 on x1.kpu_rcd = l1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
WHERE x1.kpu_tn < 4000000000
  AND MOD(TRUNC(Kpu_Flg / 64), 2) = 0
  and BITAND(c1.kpu_flg, 2) = 0