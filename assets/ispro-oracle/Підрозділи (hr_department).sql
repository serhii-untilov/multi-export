-- Підрозділи (hr_department)
-- TODO: ORA-00942: table or view does not exist
-- /*SYSSTE_BEGIN*/
WITH ste1 AS (
    SELECT max(sysste_rcd) sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
)
-- /*SYSSTE_END*/
SELECT
    sprpdr_rcd "ID",
    SprPdr_Pd "code",
    sprpdr_nm "name",
    sprpdr_prcd "parentUnitID",
    'ACTIVE' "state",
    SprPdr_NmFull "fullName",
    SprPdr_NmFull "description",
    substr(sprpdr_nm, 1, 128) "nameGen",
    SprPdr_NmFull "fullNameGen",
    substr(sprpdr_datPd, 1, 128) "nameDat",
    substr(sprpdr_rodPd, 1, 128) "nameOr",
    sprpdr_datPd "fullNameDat",
	TO_CHAR(SprPdr_DatN, 'YYYY-MM-DD') dateFrom,
	case
        when SprPdr_DatK <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '9999-12-31'
        when SprPdr_DatK >= TO_DATE('2054-12-31', 'YYYY-MM-DD') then '9999-12-31'
        else TO_CHAR(SprPdr_DatK, 'YYYY-MM-DD')
        end dateTo
FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sprpdr
-- /*SYSSTE_BEGIN*/
INNER JOIN ste1 ON ste1.sysste_rcd = sprpdr.SprPdr_SteRcd
-- /*SYSSTE_END*/
WHERE SprPdr_Rcd <> 0
  AND (
        sprpdr_flg = 0
        OR EXISTS (
            SELECT null
            FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1
            WHERE kpuprkz_pdrcd = sprpdr_rcd
        )
      )
