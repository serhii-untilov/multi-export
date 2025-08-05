-- Контакти (hr_employeeContact)
WITH
    base_email AS (
        SELECT
            TO_CHAR(c1.kpu_rcd) AS "employeeID",
            c1.kpu_cdnlp AS "taxCode",
            c1.kpu_fio AS "fullFIO",
            CASE
                WHEN c1.kpu_dtroj <= DATE '1876-12-31' THEN ''
                ELSE TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD')
            END AS "birthDate",
            '1' AS "contactTypeID",
            'email' AS "contactTypeCode",
            c1.kpu_email AS "value"
        FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1
        JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 ON x1.kpu_rcd = c1.kpu_rcd AND x1.kpu_tnosn = 0
        /*SYSSTE_BEGIN*/
		JOIN (
		    SELECT MAX(sysste_rcd) AS sysste_rcd
		    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
		    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
		) ste1 ON ste1.sysste_rcd = c1.kpuc_se
		/*SYSSTE_END*/
        WHERE LENGTH(TRIM(c1.kpu_email)) > 0
    ),
    base_address AS (
        SELECT
            TO_CHAR(c1.kpu_rcd) AS "employeeID",
            c1.kpu_cdnlp AS "taxCode",
            c1.kpu_fio AS "fullFIO",
            CASE
                WHEN c1.kpu_dtroj <= DATE '1876-12-31' THEN ''
                ELSE TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD')
            END AS "birthDate",
            CASE WHEN a1.kpuadr_cd = 1 THEN '2' ELSE '3' END AS "contactTypeID",
            CASE WHEN a1.kpuadr_cd = 1 THEN 'legalAddr' ELSE 'actualAddr' END AS "contactTypeCode",
            CASE 
                WHEN LENGTH(TRIM(a1.KpuAdr_S)) > 0 THEN a1.KpuAdr_S
                ELSE 
                    TRIM(
                        NVL(a1.KpuAdr_Index || ', ', '') ||
                        NVL(a1.KpuAdr_CntNm || ', ', '') ||
                        NVL(a1.KpuAdr_RegNm || ', ', '') ||
                        NVL(a1.KpuAdr_ZoneN || ' р-н, ', '') ||
                        NVL('м.' || a1.KpuAdr_TownN || ', ', '') ||
                        NVL(a1.KpuAdr_PlacN || ', ', '') ||
                        NVL(a1.KpuAdr_StrN || ', ', '') ||
                        NVL(a1.KpuAdr_House || ', ', '') ||
                        NVL(a1.KpuAdr_Korp || ', ', '') ||
                        NVL(a1.KpuAdr_Flat, '')
                    )
            END AS "value"
        FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.KpuAdr1 a1
        JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 ON c1.kpu_rcd = a1.kpu_rcd
        JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 ON x1.kpu_rcd = c1.kpu_rcd AND x1.kpu_tnosn = 0
        /*SYSSTE_BEGIN*/
		JOIN (
		    SELECT MAX(sysste_rcd) AS sysste_rcd
		    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
		    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
		) ste1 ON ste1.sysste_rcd = c1.kpuc_se
		/*SYSSTE_END*/
        WHERE a1.kpuadr_cd IN (1,2)
    ),
    base_phone AS (
        SELECT
            TO_CHAR(c1.kpu_rcd) AS "employeeID",
            c1.kpu_cdnlp AS "taxCode",
            c1.kpu_fio AS "fullFIO",
            CASE
                WHEN c1.kpu_dtroj <= DATE '1876-12-31' THEN ''
                ELSE TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD')
            END AS "birthDate",
            '4' AS "contactTypeID",
            'phone' AS "contactTypeCode",
            c1.Kpu_Tel AS "value"
        FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1
        JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 ON x1.kpu_rcd = c1.kpu_rcd AND x1.kpu_tnosn = 0
        /*SYSSTE_BEGIN*/
		JOIN (
		    SELECT MAX(sysste_rcd) AS sysste_rcd
		    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
		    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
		) ste1 ON ste1.sysste_rcd = c1.kpuc_se
		/*SYSSTE_END*/
        WHERE LENGTH(TRIM(c1.kpu_email)) > 0
    ),
    base_mobphone AS (
        SELECT
            TO_CHAR(c1.kpu_rcd) AS "employeeID",
            c1.kpu_cdnlp AS "taxCode",
            c1.kpu_fio AS "fullFIO",
            CASE
                WHEN c1.kpu_dtroj <= DATE '1876-12-31' THEN ''
                ELSE TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD')
            END AS "birthDate",
            '4' AS "contactTypeID",
            'phone' AS "contactTypeCode",
            c1.Kpu_TelM AS "value"
        FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1
        JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 ON x1.kpu_rcd = c1.kpu_rcd AND x1.kpu_tnosn = 0
        /*SYSSTE_BEGIN*/
		JOIN (
		    SELECT MAX(sysste_rcd) AS sysste_rcd
		    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
		    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
		) ste1 ON ste1.sysste_rcd = c1.kpuc_se
		/*SYSSTE_END*/
        WHERE LENGTH(TRIM(c1.kpu_email)) > 0
    )
SELECT *
FROM (
    SELECT * FROM base_email
    UNION ALL
    SELECT * FROM base_address
    UNION ALL
    SELECT * FROM base_phone
    UNION ALL
    SELECT * FROM base_mobphone
) t1
