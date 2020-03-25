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
	,'' dictProfessionID	
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
from SPRDOL
where sprd_prz = 0 or exists (
	select null
	from kpuprk1
	where kpuprkz_dol = SprD_Cd
)