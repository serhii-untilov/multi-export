-- ������� ����� (������� �������) (hr_position)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
/*BEGIN-OF-HEAD*/
select 
	'ID' ID, 'code' code, 'name' name, 'fullName' fullName, 'parentUnitID' parentUnitID, 'state' state, 'psCategory' psCategory, 'positionType' positionType, 
	'dictProfessionID' dictProfessionID, 'dictWagePayID' dictWagePayID, 'description' description, 'nameGen' nameGen, 'nameDat' nameDat, 'fullNameGen' fullNameGen, 
	'fullNameDat' fullNameDat, 'nameOr' nameOr, 'fullNameOr' fullNameOr, 'quantity' quantity, 'personalType' personalType, 'positionCategory' positionCategory,
	'dictStatePayID' dictStatePayID, 'accrualSum' accrualSum, 'payElID' payElID, 'dictStaffCatID' dictStaffCatID, 'dictFundSourceID' dictFundSourceID, 'nameAcc' nameAcc,
	'fullNameAcc' fullNameAcc, 'entryOrderID' entryOrderID, 'nameLoc' nameLoc, 'fullNameLoc' fullNameLoc, 'nameNom' nameNom, 'nameVoc' nameVoc, 'fullNameNom' fullNameNom,
	'fullNameVoc' fullNameVoc, 'liquidate' liquidate,
	'dictPositionID' dictPositionID
union all	
/*END-OF-HEAD*/
select 
	--cast(SprD_Cd as varchar) ID,
	cast(positionID as varchar) ID,
	cast(SprD_Cd as varchar) code,
	case when sprD_NmIm is null or len(sprD_NmIm) = 0 then cast(SprD_Cd as varchar) else sprD_NmIm end name,
	case when sprD_NmIm is null or len(sprD_NmIm) = 0 then cast(SprD_Cd as varchar) else sprD_NmIm end fullName,
	--null parentUnitID,
	cast(departmentID as varchar) parentUnitID,
	'ACTIVE' state,
	null psCategory,	
	null positionType,
	null dictProfessionID,	
	null dictWagePayID,	
	sprD_NmIm description,	
	sprD_NmIm nameGen,	
	sprD_NmD nameDat,	
	sprD_NmIm fullNameGen,	
	sprD_NmD fullNameDat,	
	sprD_NmT nameOr,
	sprD_NmT fullNameOr,	
	'0' quantity,
	null personalType,	
	null positionCategory,	
	null dictStatePayID,	
	null accrualSum,	
	null payElID,	
	null dictStaffCatID,	
	null dictFundSourceID,	
	sprD_NmIm nameAcc,	
	sprD_NmIm fullNameAcc,	
	null entryOrderID,	
	sprD_NmIm nameLoc,	
	sprD_NmIm fullNameLoc,	
	sprD_NmIm nameNom,	
	sprD_NmIm nameVoc,	
	sprD_NmIm fullNameNom,	
	sprD_NmIm fullNameVoc,	
	'0' liquidate,
	cast(SprD_Cd as varchar) dictPositionID
from SPRDOL
inner join (
	select distinct kpuprk1.kpuprkz_pdrcd * 10000 + kpuprk1.kpuprkz_dol positionID, kpuprk1.kpuprkz_pdrcd departmentID, kpuprk1.kpuprkz_dol dictPositionID
	from kpuprk1
	inner join kpuc1 c1 on c1.kpu_rcd = kpuprk1.kpu_rcd
	where (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
) t1 on t1.dictPositionID = SprD_Cd
where sprd_prz = 0 or exists (
	select null
	from kpuprk1
	inner join kpuc1 c1 on c1.kpu_rcd = kpuprk1.kpu_rcd
	where kpuprkz_dol = SprD_Cd
		and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
)