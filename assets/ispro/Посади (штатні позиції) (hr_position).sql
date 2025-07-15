-- Посади (штатні позиції) (hr_position)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @employeeDateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 0) * 10000 + 101 as varchar(10)) as date)))
select
	--cast(SprD_Cd as varchar) ID,
	cast(positionID as varchar) ID,
	cast(SprD_Cd as varchar) code,
	case when sprD_NmIm is null or len(sprD_NmIm) = 0 then cast(SprD_Cd as varchar) else sprD_NmIm end name,
	case when sprD_NmIm is null or len(sprD_NmIm) = 0 then cast(SprD_Cd as varchar) else sprD_NmIm end fullName,
	--null parentUnitID,
	cast(departmentID as varchar) parentUnitID,
	--'ACTIVE' state,
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
		and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)
) t1 on t1.dictPositionID = SprD_Cd
where sprd_prz = 0 or exists (
	select null
	from kpuprk1
	inner join kpuc1 c1 on c1.kpu_rcd = kpuprk1.kpu_rcd
	where kpuprkz_dol = SprD_Cd
		and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
		and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)
)