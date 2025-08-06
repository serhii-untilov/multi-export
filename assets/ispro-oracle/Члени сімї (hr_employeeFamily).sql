-- Члени сімї (hr_employeeFamily)
select 
	KpuSem_Rcd "ID"
	,s1.kpu_rcd "employeeID"	
	,c1.kpu_cdnlp "taxCode"
	,c1.kpu_fio "fullFIO"
	,CASE WHEN c1.kpu_dtroj > TO_DATE('1876-12-31', 'YYYY-MM-DD') THEN TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD') ELSE '' end "birthDate"
	,CASE WHEN s1.KpuSem_Dt > TO_DATE('1876-12-31', 'YYYY-MM-DD') THEN TO_CHAR(s1.KpuSem_Dt, 'YYYY-MM-DD') ELSE '' end "relativeBirthDate"
	,'9999-12-31' dateTo	
	,case when s1.KpuSem_Cd is null then '' else TO_CHAR(s1.KpuSem_Cd) end "dictKinshipKindID"
	,case 
		when p1.spr_nm like '%доч%' then '1' 
		when p1.spr_nm like '%син%' then '2'
		when p1.spr_nm like '%сын%' then '3'
		else '0' end "isDependent"	
	,case when s1.KpuSem_Dt <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '' else TO_CHAR(s1.KpuSem_Dt, 'YYYY-MM-DD') end || ' ' || coalesce(p1.spr_nm, ' ') || ' ' || s1.kpusem_fio "description"	
	,case 
		when length(s1.KpuSem_TelMob) > 0 then 'тел. ' || s1.KpuSem_TelMob 
		when length(s1.KpuSem_TelDom) > 0 then 'тел. ' || s1.KpuSem_TelDom
		when length(s1.KpuSem_TelSlg) > 0 then 'тел. ' || s1.KpuSem_TelSlg
		end "comment"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.KpuSem1 s1
join /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 c1 ON c1.Kpu_Rcd = s1.Kpu_Rcd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 ON x1.kpu_rcd = c1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
left join /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr p1 on p1.sprspr_cd = 680980 and p1.spr_cd = s1.kpusem_cd