-- Розрахункові листи працівників (hr_accrual)
WITH currentPeriod AS (
    SELECT /*+ MATERIALIZE */
        CASE
            WHEN LENGTH(TRIM(v1.CrtParm_Val)) = 8 THEN TO_DATE(v1.CrtParm_Val, 'DD/MM/RR')
            ELSE TO_DATE(v1.CrtParm_Val, 'DD/MM/YYYY')
        END AS dateFrom
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.vwCrtParm v1
    /*SYSSTE_BEGIN*/
    JOIN (
        SELECT MAX(sysste_rcd) AS sysste_rcd
        FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
        WHERE sysste_cd = /*SYSSTE_CD*/'1500'
    ) ste1 ON ste1.sysste_rcd = v1.CrtFrm_Rcd
    /*SYSSTE_END*/
    WHERE v1.crtParm_cdBpr = 2
      AND v1.crtParm_id = 'Period_DatOpen'
),
n1 as (
    SELECT /*+ MATERIALIZE */
        n1.kpu_rcd, kpunch_cd, kpunch_rcd, MIN(kpunch_id) AS kpunch_id
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpunch1 n1
    inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = n1.kpu_rcd
    /*SYSSTE_BEGIN*/
    JOIN (
        SELECT MAX(sysste_rcd) AS sysste_rcd
        FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
        WHERE sysste_cd = /*SYSSTE_CD*/'1500'
    ) ste1 ON ste1.sysste_rcd = c1.kpuc_se
    /*SYSSTE_END*/
    GROUP BY n1.kpu_rcd, kpunch_cd, kpunch_rcd
),
u1 as (
    SELECT /*+ MATERIALIZE */
        u1.kpu_rcd, kpuudr_cd, kpuudr_rcd, MIN(kpuudr_id) AS kpuudr_id
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuudr1 u1
    inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = u1.kpu_rcd
    /*SYSSTE_BEGIN*/
    JOIN (
        SELECT MAX(sysste_rcd) AS sysste_rcd
        FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
        WHERE sysste_cd = /*SYSSTE_CD*/'1500'
    ) ste1 ON ste1.sysste_rcd = c1.kpuc_se
    /*SYSSTE_END*/
    GROUP BY u1.kpu_rcd, kpuudr_cd, kpuudr_rcd
)
SELECT
    r1.bookmark AS "ID",
    TO_CHAR(r1.kpurl_datUp, 'YYYY-MM-DD') AS "periodCalc",
    TO_CHAR(r1.kpurl_datRp, 'YYYY-MM-DD') AS "periodSalary",
    x1.kpu_tn AS "tabNum",
    x1.kpu_rcd AS "employeeNumberID",
    r1.kpurl_cdvo AS "payElID",

    TO_CHAR(
        CASE
            WHEN BITAND(r1.kpurl_prz, 8) = 0 THEN r1.kpurlPl_Sm
            ELSE -r1.kpurlPl_Sm
        END / POWER(10, r1.KpuRlPl_SmMT)
    , 'FM9990.99', 'NLS_NUMERIC_CHARACTERS = ''.,''') AS "baseSum",

    TO_CHAR(r1.kpurlPl_Prc / POWER(10, r1.KpuRlPl_PrcMT), 'FM9990.99', 'NLS_NUMERIC_CHARACTERS = ''.,''') AS "rate",

    TO_CHAR(r1.kpurl_Sm / 100, 'FM9990.99', 'NLS_NUMERIC_CHARACTERS = ''.,''') AS "paySum",

    CASE
        WHEN BITAND(r1.kpurl_prz, 8) = 0 THEN r1.kpurl_days
        ELSE -r1.kpurl_days
    END AS "days",
    CASE
        WHEN BITAND(r1.kpurl_prz, 8) = 0 THEN r1.kpurl_hrs
        ELSE -r1.kpurl_hrs
    END AS "hours",
    CASE
        WHEN r1.KpuRlTS_Dat <= TO_DATE('1876-12-31', 'YYYY-MM-DD') THEN ''
        ELSE TO_CHAR(r1.KpuRlTS_Dat, 'YYYY-MM-DD')
    END AS "calculateDate",
    r1.KpuRl_Msk AS "mask",
    /*FIRM_SCHEMA*/ISPRO_8_PROD.BIT_OR(
      /*FIRM_SCHEMA*/ISPRO_8_PROD.BIT_OR(
        /*FIRM_SCHEMA*/ISPRO_8_PROD.BIT_OR(
          /*FIRM_SCHEMA*/ISPRO_8_PROD.BIT_OR(
            /*FIRM_SCHEMA*/ISPRO_8_PROD.BIT_OR(
              /*FIRM_SCHEMA*/ISPRO_8_PROD.BIT_OR(
                /*FIRM_SCHEMA*/ISPRO_8_PROD.BIT_OR(
                  /*FIRM_SCHEMA*/ISPRO_8_PROD.BIT_OR(
                    /*FIRM_SCHEMA*/ISPRO_8_PROD.BIT_OR(
                      /*FIRM_SCHEMA*/ISPRO_8_PROD.BIT_OR(
                        /*FIRM_SCHEMA*/ISPRO_8_PROD.BIT_OR(
                          /*FIRM_SCHEMA*/ISPRO_8_PROD.BIT_OR(
                            /*FIRM_SCHEMA*/ISPRO_8_PROD.BIT_OR(
                              8,
                              CASE WHEN BITAND(r1.KpuRl_Prz, 8) <> 0 THEN 512 ELSE 0 END
                            ),
                            CASE WHEN BITAND(r1.KpuRl_Prz, 16) <> 0 THEN 1024 ELSE 0 END
                          ),
                          CASE WHEN r1.KpuRlSvm_Tn <> 0 THEN 4096 ELSE 0 END
                        ),
                        CASE WHEN r1.KpuRlSvm_Tn <> 0 THEN 8192 ELSE 0 END
                      ),
                      CASE WHEN BITAND(r1.KpuRl_Prz, 65536) <> 0 THEN 4096 ELSE 0 END
                    ),
                    CASE WHEN BITAND(r1.KpuRl_Prz, 65536) <> 0 THEN 8192 ELSE 0 END
                  ),
                  CASE WHEN v1.Vo_NUR <> 0 THEN 8192 ELSE 0 END
                ),
                CASE WHEN BITAND(r1.KpuRl_Prz, 2) <> 0 THEN 4 ELSE 0 END
              ),
              CASE WHEN BITAND(r1.KpuRl_Prz, 1) <> 0 THEN 1 ELSE 0 END
            ),
            CASE WHEN BITAND(r1.KpuRl_Prz, 4) <> 0 THEN 2 ELSE 0 END
          ),
          CASE WHEN BITAND(r1.KpuRl_Prz, 262144) <> 0 THEN 32 ELSE 0 END
        ),
        CASE WHEN BITAND(r1.KpuRl_Prz, 16) <> 0 THEN 1024 ELSE 0 END
      ),
      CASE WHEN v1.vo_met = 117 AND kmPl.kpurlclc_sm IS NOT NULL AND BITAND(kmPl.kpurlclc_sm, 64) <> 0 THEN 256 ELSE 0 END
    ) AS "flagsRec",
    CASE
        WHEN v1.Vo_Grp < 128 AND /*FIRM_SCHEMA*/ISPRO_8_PROD.BIT_OR(r1.KpuRl_Msk, r1.kpurl_addmsk) = 0 THEN 2147483647
        ELSE 0
    END AS "flagsFix",
    r1.kpurlPl_hrs AS "planHours",
    r1.kpurlPl_days AS "planDays",
    r1.kpurl_addmsk AS "maskAdd",
    CASE
        WHEN r1.KpuRlPr_Dn <= TO_DATE('1876-12-31', 'YYYY-MM-DD') THEN ''
        ELSE TO_CHAR(r1.KpuRlPr_Dn, 'YYYY-MM-DD')
    END AS "dateFrom",
    CASE
        WHEN r1.KpuRlPr_Dk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') THEN ''
        ELSE TO_CHAR(r1.KpuRlPr_Dk, 'YYYY-MM-DD')
    END AS "dateTo",
    CASE
        WHEN r1.KpuRlSvm_Tn <> 0 THEN ''
        WHEN n2.pdnch_rcd IS NOT NULL THEN 'hr_payPerm'
        WHEN n1.kpunch_id IS NOT NULL THEN 'hr_employeeAccrual'
        WHEN u2.pdudr_rcd IS NOT NULL THEN 'hr_payPerm'
        WHEN u1.kpuudr_id IS NOT NULL THEN 'hr_payRetention'
        -- WHEN p1.bookmark IS NOT NULL THEN 'hr_employeePosition'
        ELSE ''
    END AS "source",
    CASE
        WHEN r1.KpuRlSvm_Tn <> 0 THEN ''
        WHEN n2.pdnch_rcd IS NOT NULL THEN TO_CHAR(n2.pdnch_rcd)
        WHEN n1.kpunch_id IS NOT NULL THEN TO_CHAR(n1.kpunch_id)
        WHEN u2.pdudr_rcd IS NOT NULL THEN TO_CHAR(65535 + u2.pdudr_rcd)
        WHEN u1.kpuudr_id IS NOT NULL THEN TO_CHAR(u1.kpuudr_id)
        -- WHEN p1.bookmark IS NOT NULL THEN TO_CHAR(p1.bookmark)
        ELSE ''
    END AS "sourceID",
    CASE
        WHEN r1.KpuRlPrZr_Dn <= TO_DATE('1876-12-31', 'YYYY-MM-DD') THEN ''
        ELSE TO_CHAR(r1.KpuRlPrZr_Dn, 'YYYY-MM-DD')
    END AS "dateFromAvg",
    CASE
        WHEN r1.KpuRlPrZr_Dk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') THEN ''
        ELSE TO_CHAR(r1.KpuRlPrZr_Dk, 'YYYY-MM-DD')
    END AS "dateToAvg",
    TO_CHAR(KpuRlPl_SrZ, 'FM9990.99', 'NLS_NUMERIC_CHARACTERS = ''.,''') AS "sumAvg",
    CASE
        WHEN r1.KpuRlSvm_Tn = 0 THEN ''
        ELSE TO_CHAR(svm.Kpu_Rcd)
    END AS "employeeNumberPartID"
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpurlo1 r1
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUX x1 ON x1.Kpu_Tn = r1.Kpu_Tn
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 c1 ON c1.Kpu_Rcd = x1.kpu_rcd
JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.PAYVO1 v1 ON v1.Vo_Cd = r1.kpurl_cdvo
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
LEFT JOIN n1 ON v1.vo_grp < 128
    AND n1.kpu_rcd = x1.kpu_rcd
    AND n1.kpunch_cd = r1.kpurl_cdvo
    AND r1.kpurllnk_ls = n1.kpunch_rcd
    AND BITAND(r1.kpurl_prz, 16384) = 0
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.pdnch n2 ON v1.vo_grp < 128
    AND n2.pdnch_cd = r1.kpurl_cdvo
    AND r1.kpurllnk_ls = n2.pdnch_rcd
    AND BITAND(r1.kpurl_prz, 16384) <> 0
LEFT JOIN u1 ON v1.vo_grp > 127
    AND u1.kpu_rcd = x1.kpu_rcd
    AND u1.kpuudr_cd = r1.kpurl_cdvo
    AND r1.kpurllnk_ls = u1.kpuudr_rcd
    AND BITAND(r1.kpurl_prz, 16384) = 0
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.pdudr u2 ON v1.vo_grp > 127
    AND u2.pdudr_cd = r1.kpurl_cdvo
    AND r1.kpurllnk_ls = u2.pdudr_rcd
    AND BITAND(r1.kpurl_prz, 16384) <> 0
-- LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 p1 ON v1.vo_grp = 1
--     AND r1.KpuRlPr_Dn >= r1.kpurl_datrp
--     AND p1.kpu_rcd = x1.kpu_rcd
--     AND p1.bookmark = (
--         SELECT MIN(p2.bookmark)
--         FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 p2
--         WHERE p2.kpu_rcd = x1.kpu_rcd
--           AND p2.kpuprkz_dtv = (
--               SELECT MAX(p3.kpuprkz_dtv)
--               FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 p3
--               WHERE p3.kpu_rcd = x1.kpu_rcd
--                 AND p3.kpuprkz_dtv <= r1.KpuRlPr_Dn
--           )
--     )
--     AND r1.kpurl_cdvo = p1.kpuprkz_sysop
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux svm ON svm.kpu_tn = r1.KpuRlSvm_Tn
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.kpurloclc kmPl ON kmPl.kpu_tn = r1.kpu_tn
    AND kmPl.KpuRl_DatRp = r1.KpuRl_DatRp
    AND kmPl.KpuRl_Rcd = r1.KpuRl_Rcd
    AND v1.vo_met = 117
    AND kmPl.kpurlclc_pk = 14
WHERE r1.KpuRl_CdVo <> 0
  AND r1.KpuRl_DatUp >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
  AND r1.KpuRl_DatUp < (SELECT dateFrom FROM currentPeriod)
