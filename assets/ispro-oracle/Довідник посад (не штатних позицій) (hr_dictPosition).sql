-- Довідник посад (не штатних позицій) (hr_dictPosition)
with
	position as (
		select
			/*+ MATERIALIZE */distinct p1.kpuprkz_dol AS cd
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 p1
		join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = p1.kpu_rcd
			/*SYSSTE_BEGIN*/
			JOIN (
				SELECT MAX(sysste_rcd) AS sysste_rcd
				FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
				WHERE sysste_cd = /*SYSSTE_CD*/'1500'
			) ste1 ON ste1.sysste_rcd = c1.kpuc_se
			/*SYSSTE_END*/
	)
select
	SprD_Cd "ID",
	SprD_Cd "code",
	CASE
		WHEN sprD_NmIm IS NULL
		OR LENGTH (sprD_NmIm) = 0 THEN TO_CHAR (SprD_Cd)
		ELSE sprD_NmIm
	END AS "name",
	CASE
		WHEN sprD_NmIm IS NULL
		OR LENGTH (sprD_NmIm) = 0 THEN TO_CHAR (SprD_Cd)
		ELSE sprD_NmIm
	END AS "fullName",
	'' "idxNum",
	'' "dateFrom",
	'' "dateTo"
	--	,case when c1.sdolcl_rcd is null then 'NULL' else cast(c1.sdolcl_rcd as varchar) end dictProfessionID
,
	'' "dictProfessionID",
	sprd_klcd "dictProfessionCode",
	sprd_zkpptr "dictProfessionZKPPTR",
	sprD_NmIm "nameGen",
	sprD_NmD "nameDat",
	sprD_NmD "nameAcc",
	sprD_NmT "nameOr",
	sprD_NmIm "nameLoc",
	sprD_NmIm "nameVoc",
	sprD_NmIm "fullNameNom",
	sprD_NmIm "fullNameGen",
	sprD_NmD "fullNameDat",
	sprD_NmIm "fullNameAcc",
	sprD_NmT "fullNameOr",
	sprD_NmIm "fullNameLoc",
	sprD_NmIm "fullNameVoc",
	'' "nameForeign",
	'' "dictStaffCatID",
	'' "dictWagePayID",
	'' "positionCategory",
	'' "dictStatePayID",
	sprD_NmIm || ' [' || TO_CHAR (SprD_Cd) || ']' "description",
	sprD_NmIm "nameNom",
	'' "psCategory",
	'1' "isActive"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.SPRDOL d1
inner join position p1 on p1.cd = d1.SprD_Cd