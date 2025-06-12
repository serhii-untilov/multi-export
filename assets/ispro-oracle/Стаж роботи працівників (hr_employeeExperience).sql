-- Стаж роботи працівників (hr_employeeExperience)
SELECT 
    ROW_NUMBER() OVER(ORDER BY employeeID, dictExperienceID ASC) "ID",
    employeeID "employeeID",
    dictExperienceID "dictExperienceID",
    TO_CHAR(calcDate, 'YYYY-MM-DD') "calcDate",
    '' AS "startCalcDate",
    '' AS "comment",
    '' AS "impEmployeeID",
    '' AS "importInfo",
    CASE 
        WHEN employeeNumberID IS NULL THEN '' 
        ELSE TO_CHAR(employeeNumberID) 
    END AS "employeeNumberID"
FROM (
	-- 1 Загальний стаж ----------------------------
	select
		c1.kpu_rcd employeeID
		,1 dictExperienceID
		,Kpu_DtObSt calcDate
		,null employeeNumberID
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1
	inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd
	/*SYSSTE_BEGIN*/
	JOIN (
		SELECT MAX(sysste_rcd) AS sysste_rcd
		FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
		WHERE sysste_cd = /*SYSSTE_CD*/'1500'
	) ste1 ON ste1.sysste_rcd = c1.kpuc_se
	/*SYSSTE_END*/
	where x1.kpu_tnosn = 0 
		and Kpu_DtObSt > TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		and c1.Kpu_Rcd < 4000000000
		and BITAND(c1.Kpu_Flg, 2) = 0	-- Не сумісник
	-- 2 -----------------------------------------
	union all
	select
		c1.kpu_rcd employeeID
		,2 dictExperienceID
		,Kpu_DtNpSt calcDate
		,null employeeNumberID
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1
	inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd
	/*SYSSTE_BEGIN*/
	JOIN (
		SELECT MAX(sysste_rcd) AS sysste_rcd
		FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
		WHERE sysste_cd = /*SYSSTE_CD*/'1500'
	) ste1 ON ste1.sysste_rcd = c1.kpuc_se
	/*SYSSTE_END*/
	where x1.kpu_tnosn = 0 
		and Kpu_DtNpSt > TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		and c1.Kpu_Rcd < 4000000000
		and BITAND(c1.Kpu_Flg, 2) = 0
	-- 3 -----------------------------------------
	union all
	select
		c1.kpu_rcd employeeID --CASE WHEN ISNUMERIC(kpu_cdnlp) = 1 THEN CAST(kpu_cdnlp AS numeric) ELSE c1.kpu_rcd END employeeID
		,3 dictExperienceID
		,Kpu_DtOrgSt calcDate --min(Kpu_DtOrgSt) calcDate
		,null employeeNumberID
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1
	inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd
	/*SYSSTE_BEGIN*/
	JOIN (
		SELECT MAX(sysste_rcd) AS sysste_rcd
		FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
		WHERE sysste_cd = /*SYSSTE_CD*/'1500'
	) ste1 ON ste1.sysste_rcd = c1.kpuc_se
	/*SYSSTE_END*/
	where x1.kpu_tnosn = 0 
		and Kpu_DtOrgSt > TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		and c1.Kpu_Rcd < 4000000000
		and BITAND(c1.Kpu_Flg, 2) = 0
	-- 4 -----------------------------------------
	union all
	select
		c1.kpu_rcd employeeID
		,4 dictExperienceID
		,Kpu_DtSrSt calcDate
		,null employeeNumberID
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1
	inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd
	/*SYSSTE_BEGIN*/
	JOIN (
		SELECT MAX(sysste_rcd) AS sysste_rcd
		FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
		WHERE sysste_cd = /*SYSSTE_CD*/'1500'
	) ste1 ON ste1.sysste_rcd = c1.kpuc_se
	/*SYSSTE_END*/
	where x1.kpu_tnosn = 0 
		and Kpu_DtSrSt > TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		and c1.Kpu_Rcd < 4000000000
		and BITAND(c1.Kpu_Flg, 2) = 0
	-- 5 -----------------------------------------
	union all
	select
		c1.kpu_rcd employeeID
		,5 dictExperienceID
		,Kpu_DtOtrSt calcDate
		,null employeeNumberID
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1
	inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd
	/*SYSSTE_BEGIN*/
	JOIN (
		SELECT MAX(sysste_rcd) AS sysste_rcd
		FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
		WHERE sysste_cd = /*SYSSTE_CD*/'1500'
	) ste1 ON ste1.sysste_rcd = c1.kpuc_se
	/*SYSSTE_END*/
	where x1.kpu_tnosn = 0 
		and Kpu_DtOtrSt > TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		and c1.Kpu_Rcd < 4000000000
		and BITAND(c1.Kpu_Flg, 2) = 0
	-- 6 -----------------------------------------
	union all
	select
		c1.kpu_rcd employeeID
		,6 dictExperienceID
		,Kpu_DtGS calcDate
		,null employeeNumberID
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1
	join /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd
	/*SYSSTE_BEGIN*/
	JOIN (
		SELECT MAX(sysste_rcd) AS sysste_rcd
		FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
		WHERE sysste_cd = /*SYSSTE_CD*/'1500'
	) ste1 ON ste1.sysste_rcd = c1.kpuc_se
	/*SYSSTE_END*/
	where x1.kpu_tnosn = 0 
		and Kpu_DtGS > TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		and c1.Kpu_Rcd < 4000000000
		and BITAND(c1.Kpu_Flg, 2) = 0
	-- 7 -----------------------------------------
	union all
	select
		c1.kpu_rcd employeeID
		,7 dictExperienceID
		,Kpu_DtGSNp calcDate
		,null employeeNumberID
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1
	inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUX x1 on x1.Kpu_Rcd = c1.kpu_rcd
	/*SYSSTE_BEGIN*/
	JOIN (
		SELECT MAX(sysste_rcd) AS sysste_rcd
		FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
		WHERE sysste_cd = /*SYSSTE_CD*/'1500'
	) ste1 ON ste1.sysste_rcd = c1.kpuc_se
	/*SYSSTE_END*/
	where x1.kpu_tnosn = 0 
		and Kpu_DtGSNp > TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		and c1.Kpu_Rcd < 4000000000
		and BITAND(c1.Kpu_Flg, 2) = 0
	-- 8 -----------------------------------------
	UNION ALL
    SELECT 
        c1.kpu_rcd employeeID,
        s1.kpustg_cd + 10 dictExperienceID,
        -- Oracle-style DATEADD with subtraction of days from SYSDATE
        SYSDATE - SUM(
            CASE 
                WHEN s1.KpuAStg_DtK <= TO_DATE('1876-12-31', 'YYYY-MM-DD') 
                    THEN TRUNC(SYSDATE) - TRUNC(s1.KpuAStg_DtN)
                ELSE TRUNC(s1.KpuAStg_DtK) - TRUNC(s1.KpuAStg_DtN)
            END
        ) AS calcDate,
        x1.kpu_rcd AS employeeNumberID
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.KpuAdStgDat1 s1
    JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 c1 ON c1.Kpu_Rcd = s1.kpu_rcd
    JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUX x1 ON x1.Kpu_Rcd = s1.kpu_rcd
    /*SYSSTE_BEGIN*/
    JOIN (
        SELECT MAX(sysste_rcd) AS sysste_rcd
        FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
        WHERE sysste_cd = /*SYSSTE_CD*/'1500'
    ) ste1 ON ste1.sysste_rcd = c1.kpuc_se
    /*SYSSTE_END*/
    WHERE x1.kpu_tnosn = 0
      AND c1.Kpu_Rcd < 4000000000
      AND BITAND(c1.Kpu_Flg, 2) = 0
    GROUP BY c1.kpu_rcd, s1.kpustg_cd, x1.kpu_rcd
) t1