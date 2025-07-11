-- Військовий облік (hr_empStateMilitary)

--KpuWar1 - Воинский учет
--KpuNVP1 - Начальная военная подготовка
--KpuVZBP1 - Присвоение воинских званий до поступления
--KpuBtl1 - Участие в боевых действиях

WITH 
-- Забезпечення унікальності РНОКПП {
employee AS (
	select max(kpu_rcd) ID, KPU_CDNLP taxCode
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 
	where kpu_cdnlp is not null and length(KPU_CDNLP) > 5
	GROUP BY KPU_CDNLP
)
-- Забезпечення унікальності РНОКПП }
SELECT
    --ROW_NUMBER() OVER (ORDER BY KPUC1.Kpu_CdNlp) AS "п/н",
	w1.bookmark "ID"
	,CASE WHEN employee.ID IS NOT NULL THEN employee.ID ELSE w1.kpu_rcd end "employeeID"
	,w1.kpu_rcd "employeeNumberID"
	,x1.kpu_tn "tabNum"
	,c1.kpu_cdnlp "taxCode"
	,c1.kpu_fio "fullFIO"
	,case when c1.kpu_dtroj <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '' else TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD') end "birthDate"
    ,c1.kpu_fio "fullFIO"
    ,CASE
        WHEN w1.KpuWar_VobCd = 2 THEN '03'
        WHEN w1.KpuWar_VobCd = 1 THEN '02'
        WHEN w1.KpuWar_VobCd = 3 THEN '01'
        WHEN w1.KpuWar_VobCd = 4 THEN '04'
        ELSE ''
    END AS "dictStateMilitaryID", -- Стан обліку

    w1.KpuWar_CdGr "groupAccounting", -- Група обліку

--    (SELECT Spr_NmLong
--     FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr
--     WHERE Spr_Cd = w1.KpuWar_CdGr AND sprspr_cd = 680973
--    ) AS "groupAccounting", -- Група обліку

    CASE
        WHEN KpuWar_CdKat = 1 THEN '01'
        WHEN KpuWar_CdKat = 2 THEN '02'
        ELSE ''
    END AS "dictCategMilitaryID", -- Категор. обліку

    w1.KpuWar_CdSos "composition",

--    (SELECT Spr_Nm
--     FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr
--     WHERE Spr_Cd = w1.KpuWar_CdSos AND sprspr_cd = 680975
--    ) AS "composition", -- Склад

    w1.KpuWar_CdZvn AS "dictMilitaryRankID", -- Код військ. зв.

--    (SELECT Spr_Nm
--     FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr
--     WHERE Spr_Cd = w1.KpuWar_CdZvn
--       AND sprspr_cd = 531
--    ) AS "dictMilitaryRankName", -- Військ. звання

--    KpuWar_CdSos AS "dictMilitaryProfileID", -- Код пр оф зап.

--    (SELECT Spr_Nm
--     FROM pspr
--     WHERE Spr_Cd = KpuWar1.KpuWar_CdSos
--       AND sprspr_cd = 680975) AS "impOfficerProfileName", -- Профіль оф зап

    KpuWar_NmrSp AS "dictMilitarySpecialtyID", -- ВОС

--    (SELECT Spr_Nm
--     FROM pspr
--     WHERE Spr_Cd = KpuWar1.KpuWar_doc
--       AND sprspr_cd = 681071) AS "Назва РВК", --
--    w1.KpuWar_doc AS "dictMilitaryOfficeID", -- Код РВК


--    (SELECT Spr_Nm
--     FROM pspr
--     WHERE Spr_Cd = KpuWar1.KpuWar_Godn
--       AND sprspr_cd = 680977) AS "Придатн. до ВС", --
     w1.KpuWar_Godn "dictMilitarySuitableID",

--    (SELECT Spr_Nm
--     FROM pspr
--     WHERE Spr_Cd = KpuWar1.KpuWar_Godn
--       AND sprspr_cd = 680977) AS "Придатність", -- dictMilitarySuitableID

--    '' AS "Примітки",
--    '' AS "Дата зв. запас",
--    '' AS "Був офіц. 2-3 р.",

    case when KpuWar_DtDoc <= TO_DATE('1876-12-31', 'yyyy-mm-dd') then 'null' else TO_CHAR(KpuWar_DtDoc, 'YYYY-MM-DD') end "dateIssue", -- Дата видачі ВК

    KpuWar_DocN AS "docNumber", -- Номер квитка

--    '' AS "Бронювання",
--    '' AS "Бронь строком на",

    KpuWar_Spu AS "reservationDocNumber", -- № постанови
    case when KpuWar_Beg <= TO_DATE('1876-12-31', 'yyyy-mm-dd') then 'null' else TO_CHAR(KpuWar_Beg, 'yyyy-mm-dd') END "reservationDate", -- Дата постанови
    KpuWar_Spu AS "delayDocument", -- Спецоблік

--    '' AS "Дата відстрочки",
--    '' AS "Відстрочка до",

--    (SELECT Spr_Nm
--     FROM pspr
--     WHERE Spr_Cd = KpuWar1.KpuWar_RVR
--       AND sprspr_cd = 680978) AS "РВК реєстрац.", -- office

--    '' AS "Розписка, дата",
--    '' AS "Розписка, №",

--    (SELECT Spr_Nm
--     FROM pspr
--     WHERE Spr_Cd = KpuWar1.KpuWar_CdMP
--       AND sprspr_cd = 681018) AS "Моб. розпорядж.",
    w1.KpuWar_CdMP "isMobilOrder",

    CASE
        WHEN KpuWar_EndCd = 1 THEN 'За віком'
        WHEN KpuWar_EndCd = 2 THEN 'За станом здоров''я'
        WHEN KpuWar_EndCd = 3 THEN 'Був засуджений'
        WHEN KpuWar_EndCd = 4 THEN 'Вибуття за межі України на ПМЖ'
        ELSE ''
    END AS "removalReason" -- Причина зняття

    -- KPUC1.Kpu_rcd AS "Зовнішній код"

FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.KpuWar1 w1
join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = w1.Kpu_Rcd
join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 on x1.kpu_rcd = c1.kpu_rcd and x1.kpu_tnosn = 0
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
--  AND BITAND(c1.kpu_flg, 2) = 0
--  AND x1.kpu_tnosn = 0