-- Трудова книжка (hr_employeeWorkbook)
WITH 
-- Забезпечення унікальності РНОКПП {
employee AS (
	select max(kpu_rcd) ID, KPU_CDNLP taxCode
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 
	where kpu_cdnlp is not null and length(KPU_CDNLP) > 5
	GROUP BY KPU_CDNLP
)
-- Забезпечення унікальності РНОКПП }
select 
	k1.kputd_rcd "ID"
	,x1.kpu_tn "tabNum"
	,CASE WHEN employee.ID IS NOT NULL THEN employee.ID ELSE k1.kpu_rcd END "employeeID"
	,k1.kpu_rcd "employeeNumberID"
	-- employeepositionid, 
	,TO_CHAR(k1.KpuTD_DtV, 'YYYY-MM-DD') "dateFrom"
	,case 
		when k1.KpuTD_DtK <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '9999-12-31' 
		else TO_CHAR(k1.KpuTD_DtK, 'YYYY-MM-DD') 
		end "dateTo"
	,k1.KpuTD_AdrOrg "workplace", 
	-- dictprofessionid, 
	k1.KpuTD_Dol "workposition", 
	k1.KpuTD_Com "description", 
	-- datetrialend, 
	k1.KpuTD_Osn "basedocument", 
	-- appointorder, 
	-- dismorder, 
	k1.KpuTD_Osn "appointreason" 
	-- dischargereason,	positiontype, appointmentlevel,	positioncategory, empworkplace, mtcount, organizationid, ismanualworkplace, isorgappoint, isorgdismiss, impemployeeid, impsourceid
from /*FIRM_SCHEMA*/ISPRO_8_PROD.KpuTD1 k1
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = k1.kpu_rcd
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 on x1.kpu_rcd = k1.kpu_rcd
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
WHERE x1.kpu_tn < 4000000000
  AND MOD(TRUNC(Kpu_Flg / 64), 2) = 0
  and BITAND(c1.kpu_flg, 2) = 0