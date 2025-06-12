-- Даталізація розрахункових листів (hr_accrualDt)
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
)
select 
	(r1.bookmark * 1000 + MOD(coalesce(z1.bookmark, 0), 999)) "ID"
	,r1.bookmark "accrualID"	
	,coalesce(z1.KpuRlSPZ_Sm, r1.kpurl_Sm) / 100 "paySum"	
	,r1.kpurl_SF "dictFundSourceID"
--	,case 
--        when pdr1.KpuPrkz_PdRcd > 0 then TO_CHAR(pdr1.KpuPrkz_PdRcd) 
--        else '' 
--        end "departmentID"
	,case 
        when z1.KpuRl_CdSch is not null and z1.KpuRl_CdSch > 0 then TO_CHAR(z1.KpuRl_CdSch) 
        else '' 
        end "accountID"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpurlo1 r1
join /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUX x1 on x1.Kpu_Tn = r1.Kpu_Tn
join /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUC1 c1 on c1.Kpu_Rcd = x1.kpu_rcd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
-- join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
-- 	select max(pdr2.bookmark)
-- 	from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 pdr2 
-- 	where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
-- 		select max(pdr3.kpuprkz_dtv)
-- 		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 pdr3
-- 		where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= SYSDATE
-- 	)
-- )
join /*FIRM_SCHEMA*/ISPRO_8_PROD.PAYVO1 v1 on v1.Vo_Cd = r1.kpurl_cdvo
left join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpurlospz z1 on z1.kpu_tn = r1.kpu_tn and z1.KpuRl_DatRp = r1.KpuRl_DatRp 
    and z1.KpuRl_Rcd = r1.KpuRl_Rcd
where r1.KpuRl_CdVo <> 0
	and r1.KpuRl_DatUp >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
	and r1.KpuRl_DatUp < (SELECT dateFrom FROM currentPeriod)
