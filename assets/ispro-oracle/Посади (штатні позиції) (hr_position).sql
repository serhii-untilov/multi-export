-- Посади (штатні позиції) (hr_position)
with 
/*SYSSTE_BEGIN*/
	ste1 as (
		select /*+ MATERIALIZE */
			max(sysste_rcd) sysste_rcd 
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste 
		where sysste_cd = /*SYSSTE_CD*/'1500'
	),
/*SYSSTE_END*/
	t1 as (
		select /*+ MATERIALIZE */
		distinct kpuprk1.kpuprkz_pdrcd * 10000 + kpuprk1.kpuprkz_dol positionID, kpuprk1.kpuprkz_pdrcd departmentID, kpuprk1.kpuprkz_dol dictPositionID
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1
		inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = kpuprk1.kpu_rcd
		/*SYSSTE_BEGIN*/
		inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste ste2 on ste2.sysste_rcd = c1.kpuc_se
		where sysste_cd = /*SYSSTE_CD*/'1500'
		/*SYSSTE_END*/
	)
select 
	--cast(SprD_Cd as varchar) ID,
	t1.positionID "ID",
	SprD_Cd "code",
	case when sprD_NmIm is null or length(sprD_NmIm) = 0 then TO_CHAR(SprD_Cd) else sprD_NmIm end "name",
	case when sprD_NmIm is null or length(sprD_NmIm) = 0 then TO_CHAR(SprD_Cd) else sprD_NmIm end "fullName",
	--null parentUnitID,
	TO_CHAR(departmentID) "parentUnitID",
	'ACTIVE' "state",
	'null' "psCategory",	
	'null' "positionType",
	'null' "dictProfessionID",	
	'null' "dictWagePayID",	
	sprD_NmIm "description",	
	sprD_NmIm "nameGen",	
	sprD_NmD "nameDat",	
	sprD_NmIm "fullNameGen",	
	sprD_NmD "fullNameDat",	
	sprD_NmT "nameOr",
	sprD_NmT "fullNameOr",	
	'0' "quantity",
	'null' "personalType",	
	'null' "positionCategory",	
	'null' "dictStatePayID",	
	'null' "accrualSum",	
	'null' "payElID",	
	'null' "dictStaffCatID",	
	'null' "dictFundSourceID",	
	sprD_NmIm "nameAcc",	
	sprD_NmIm "fullNameAcc",	
	'null' "entryOrderID",	
	sprD_NmIm "nameLoc",	
	sprD_NmIm "fullNameLoc",	
	sprD_NmIm "nameNom",	
	sprD_NmIm "nameVoc",	
	sprD_NmIm "fullNameNom",	
	sprD_NmIm "fullNameVoc",	
	'0' "liquidate",
	TO_CHAR(SprD_Cd) "dictPositionID"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.SPRDOL
inner join t1 on t1.dictPositionID = SprD_Cd
where 
	-- sprd_prz = 0 or 
	exists (
	select null
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1
	inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = kpuprk1.kpu_rcd
	/*SYSSTE_BEGIN*/
	inner join ste1 on ste1.sysste_rcd = c1.kpuc_se
	/*SYSSTE_END*/
	where kpuprkz_dol = SprD_Cd
)
