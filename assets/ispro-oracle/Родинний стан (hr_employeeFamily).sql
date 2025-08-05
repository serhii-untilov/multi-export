-- Родинний стан (hr_employeeFamily)
SELECT
    u1.kpuudr_ID "ID",
    u1.kpu_rcd "employeeID",
    u1.kpuudr_ID "peopleID",
    TO_CHAR(KpuUdr_DatRR, 'YYYY-MM-DD') || ' ' || KpuUdr_DatRRFio "description"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUUDR1 u1
INNER JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 ON c1.kpu_rcd = u1.kpu_rcd
INNER JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.payvo1 v1 ON v1.vo_cd = u1.kpuudr_cd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 ON x1.kpu_rcd = c1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.PtnSchk s1 ON s1.ptn_rcd = u1.kpuudr_cdplc AND s1.ptnsch_rcd = u1.kpuudr_cdbank
WHERE v1.vo_met = 19
  AND LENGTH(KpuUdr_DatRRFio) > 0
  AND BITAND(c1.kpu_flg, 2) = 0
UNION ALL
SELECT
    s1.kpusem_rcd "ID",
    s1.kpu_rcd "employeeID",
    s1.kpusem_rcd "peopleID",
    TO_CHAR(KpuSem_Dt, 'YYYY-MM-DD') || COALESCE(pspr.spr_nm, ' ') || KpuSem_Fio AS "description"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpusem1 s1
INNER JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 ON c1.kpu_rcd = s1.kpu_rcd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 ON x1.kpu_rcd = c1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr ON pspr.sprspr_cd = 680980 AND pspr.spr_cd = KpuSem_Cd
WHERE BITAND(c1.kpu_flg, 2) = 0
