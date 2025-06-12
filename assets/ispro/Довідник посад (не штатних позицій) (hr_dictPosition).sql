-- Довідник посад (не штатних позицій) (hr_dictPosition)
/*BEGIN-OF-HEAD*/
select 
	'ID' ID
	,'code' code
	,'name' name
	,'fullName' fullName
	,'idxNum' idxNum 
	,'dateFrom' dateFrom 
	,'dateTo' dateTo 
	,'dictProfessionID' dictProfessionID
	,'dictProfessionCode' dictProfessionCode
	,'dictProfessionZKPPTR' dictProfessionZKPPTR
	,'nameGen' nameGen 
	,'nameDat' nameDat 
	,'nameAcc' nameAcc 
	,'nameOr' nameOr 
	,'nameLoc' nameLoc 
	,'nameVoc' nameVoc 
	,'fullNameNom' fullNameNom 
	,'fullNameGen' fullNameGen 
	,'fullNameDat' fullNameDat 
	,'fullNameAcc' fullNameAcc 
	,'fullNameOr' fullNameOr 
	,'fullNameLoc' fullNameLoc 
	,'fullNameVoc' fullNameVoc 
	,'nameForeign' nameForeign 
	,'dictStaffCatID' dictStaffCatID 
	,'dictWagePayID' dictWagePayID 
	,'positionCategory' positionCategory
	,'dictStatePayID' dictStatePayID 
	,'description' description 
	,'nameNom' nameNom 
	,'psCategory' psCategory 
	,'isActive' isActive
union all
/*END-OF-HEAD*/
select 
	cast(SprD_Cd as varchar) ID 	
	,cast(SprD_Cd as varchar) code	
	,case when sprD_NmIm is null or len(sprD_NmIm) = 0 then cast(SprD_Cd as varchar) else sprD_NmIm end name
	,case when sprD_NmIm is null or len(sprD_NmIm) = 0 then cast(SprD_Cd as varchar) else sprD_NmIm end fullName
	,'' idxNum	
	,'' dateFrom	
	,'' dateTo	
--	,case when c1.sdolcl_rcd is null then 'NULL' else cast(c1.sdolcl_rcd as varchar) end dictProfessionID	
	,'' dictProfessionID	
	,sprd_klcd dictProfessionCode
	,sprd_zkpptr dictProfessionZKPPTR
	,sprD_NmIm nameGen
	,sprD_NmD nameDat
	,sprD_NmD nameAcc	
	,sprD_NmT nameOr	
	,sprD_NmIm nameLoc	
	,sprD_NmIm  nameVoc	
	,sprD_NmIm fullNameNom	
	,sprD_NmIm  fullNameGen	
	,sprD_NmD  fullNameDat	
	,sprD_NmIm  fullNameAcc	
	,sprD_NmT  fullNameOr	
	,sprD_NmIm  fullNameLoc	
	,sprD_NmIm  fullNameVoc	
	,'' nameForeign	
	,'' dictStaffCatID	
	,'' dictWagePayID	
	,'' positionCategory	
	,'' dictStatePayID	
	,sprD_NmIm + ' [' + cast(SprD_Cd as varchar) + ']' description	
	,sprD_NmIm  nameNom	
	,'' psCategory	
	,'1' isActive
from SPRDOL d1
-- left join /*SYS_SCHEMA*/i711_sys.dbo.SDolCL c1 on 
-- 	c1.sdolcl_zkpptr = d1.sprd_zkpptr
-- 	and c1.sdolcl_cd = d1.sprd_klcd
-- 	and len(d1.sprD_klCd) <> 0
-- 	and len(d1.sprd_zkpptr) <> 0
where sprd_prz = 0 or exists (
	select null
	from kpuprk1
	where kpuprkz_dol = SprD_Cd
)