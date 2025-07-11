-- Стягнення (hr_employeePenalty)
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
	d1.KpuDOt_Rcd "ID"
	,CASE WHEN employee.ID IS NOT NULL THEN employee.ID ELSE d1.kpu_rcd end "employeeID"
	,c1.kpu_cdnlp "taxCode"
	,d1.kpu_rcd" employeeNumberID"
	,case 
		when c1.kpu_dtroj <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '' 
		else TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD') 
		end "bitrhDate"
	,case 
		when c1.kpu_dtpst <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '' 
		else TO_CHAR(c1.kpu_dtpst, 'YYYY-MM-DD') 
		end "employeeNumberDateFrom"
	,case 
		when c1.kpu_dtuvl <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '' 
		else TO_CHAR(c1.kpu_dtuvl, 'YYYY-MM-DD') 
		end "employeeNumberDateTo"
	,case 
		when d1.KpuDOt_CdVid = 0 then '' 
		else TO_CHAR(d1.KpuDOt_CdVid) 
		end "dictPenaltyID"	-- pspr.sprspr_cd = 680972
	,case 
		when d1.KpuDOt_CdPrV = 0 then '' 
		else TO_CHAR(d1.KpuDOt_CdPrV) 
		end "dictPenaltyReasonID" -- pspr.sprspr_cd = 680971
	,'' "docIssued"
	,case 
		when d1.KpuDOt_DtV <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '' 
		else TO_CHAR(d1.KpuDOt_DtV, 'YYYY-MM-DD') 
		end "docIssuedDate"
	,case 
		when d1.KpuDOt_DtPom <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '' 
		else TO_CHAR(d1.KpuDOt_DtPom, 'YYYY-MM-DD') 
		end "dateClosed"
	,d1.KpuDOt_NmPr "docDescription"
	,d1.KpuDOt_Pr "comment"	
	,'' "orderID"
	,'' "orderDetID"	
	,'' "appealDate"	
from /*FIRM_SCHEMA*/ISPRO_8_PROD.KpuDOt1 d1
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 c1 ON c1.Kpu_Rcd = d1.Kpu_Rcd
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 on x1.kpu_rcd = c1.kpu_rcd
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
