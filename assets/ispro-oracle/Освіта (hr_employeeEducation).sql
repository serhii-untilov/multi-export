-- Освіта (hr_employeeEducation)
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
	o1.KpuObr_Rcd "ID"
	,CASE WHEN employee.ID IS NOT NULL THEN employee.ID ELSE o1.kpu_rcd end "employeeID"
	,c1.kpu_cdnlp "taxCode"
	,c1.kpu_fio "fullFIO"
	,case when c1.kpu_dtroj <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '' else TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD') end "birthDate"
	,'' "dictEducationLevelID"
	,'' "dictAreasOfEduID"
	,k1.Ptn_Nm "educationName"
	,case
		when o1.KpuObr_Pst is null then 'null'
		when LENGTH(TO_CHAR(o1.KpuObr_Pst)) = 4 then TO_CHAR(o1.KpuObr_Pst) || '-09-01'
		else 'null'
		end "dateFrom"
	,case
		when o1.KpuObr_End is null then 'null'
		when LENGTH(TO_CHAR(o1.KpuObr_End)) = 4 then TO_CHAR(o1.KpuObr_End) || '-05-01'
		else 'null'
		end "dateTo"
	,s1.spr_nm "educationForm"
	,o1.KpuObr_SpcCd "dictSpecialtyID"
	,o1.KpuObr_Kvl "qualification"
	,o1.KpuObr_UrObrCd "dictDegreeID"
	,'' "employeeDocID"
	,o1.KpuObr_TypDoc + 1000 "dictDocKindID"
	,o1.KpuObr_NmrD "docNumber"
	,o1.KpuObr_SerDoc "docSeries"
	,'' "docIssuer"
	,'' "dateIssue"
	,'' "comment"
	,o1.KpuObr_UrObrCd "educationLevelCode"
	,o1.KpuObr_UrObr "shortEducationName"
	,'' "accreditationLevel"
	,o1.KpuObr_SpcCd "specCode"
	,o1.KpuObr_CrsUch "courseYear"
	,'' "retraining"
	,'' "byStateDir"
	,o1.KpuObr_Opl "byStateMoney"
	,'' "intlCert"
	,'' "UNESCO"
	,'' "actualCurOrg"
	,'' "isMain"
	,o1.KpuObr_ZavRcd "educationOrgID" -- !!!
from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuobr1 o1
join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = o1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
left join /*SYS_SCHEMA*/ISPRO_8_PROD_SYS.sspr s1 on s1.sprspr_cd = 681008 and s1.spr_cdlng = 2 and s1.spr_cd = o1.KpuObr_Form
left join /*FIRM_SCHEMA*/ISPRO_8_PROD.PtnRk k1 on k1.Ptn_Rcd = o1.KpuObr_ZavRcd
-- Забезпечення унікальності РНОКПП {
LEFT JOIN employee ON employee.taxCode = c1.KPU_CDNLP
-- Забезпечення унікальності РНОКПП }

