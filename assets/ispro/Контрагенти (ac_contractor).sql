-- Контрагенты (ac_contractor)
/*BEGIN-OF-HEAD*/
select 'ID' ID, 'code' code, 'OKPOCode' OKPOCode, 'taxCode' taxCode, 'vatCode' vatCode, 'name' name, 'fullName' fullName, 
	'nameGen' nameGen, 'nameDat' nameDat, 'fullNameGen' fullNameGen, 'fullNameDat' fullNameDat, 'description' description, 'contrType' contrType
union all
/*END-OF-HEAD*/
select 
	cast(Ptn_Rcd as varchar) ID	
	,Ptn_Cd code	
	,case when len(Ptn_CdOKPO) <> 0 then Ptn_CdOKPO else left(('*' + Ptn_Cd + '0000000'), 8) end OKPOCode	
	,Ptn_Inn taxCode	
	,null vatCode	
	,Ptn_NmSh name	
	,Ptn_Nm fullName	
	,Ptn_NmSh nameGen	
	,null nameDat	
	,Ptn_Nm fullNameGen	
	,null fullNameDat	
	,Ptn_Nm description	
	,case when Ptn_Type = 1 then 'legalEntitie' else 'entrepreneur' end contrType	
from ptnrk
where PtnRk.Ptn_Del = 0
