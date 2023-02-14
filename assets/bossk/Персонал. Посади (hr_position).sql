declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select PR_CURRENT.pId as ID,
	Appointments.Code_appoint as code,
	Name_appoint as  name  ,
	Name_appoint as  fullName,
	2 AS positionType,
	case when Code_struct_name= 43 then null else Code_struct_name end as parentUnitID,
	--case when Code_struct_name= (select max(Struct_Code) from StructS where StructS.Struct_Lev = 0 and id_Firm=@orgID) then null else Code_struct_name end as parentUnitID,
	left(ltrim(id_OKPDTR),1) as positionCategory,
	left(ltrim(id_OKPDTR),1) as idxNum,
	'ACCRUAL' as paymentType,
	Number_w as quantity,
	dictid as dictPositionID,
	Wage as accrualSum,
	1 as payElID,
	Name_appoint as nameNom,
	Name_appoint_Acc as nameGen,
	Name_appoint_Giv as nameDat,
	Name_appoint_Acc as nameAcc,
	Name_appoint_Cre as nameOr,
	Name_appoint as fullNameNom,
	Name_appoint_Acc as fullNameGen,
	Name_appoint_Giv as fullNameDat,
	Name_appoint_Acc as fullNameAcc,
	Name_appoint_Cre as fullNameOr
from Appointments
join PR_CURRENT on Appointments.Code_Appoint=PR_CURRENT.Code_Appoint
Join people on PR_CURRENT.Auto_Card = people.Auto_Card
join (select max(db_id) as dictid, Name_appoint as  dictname from Appointments group by Name_appoint) grp on  Name_appoint = dictname
join (select people.Num_Tab as tabn, max(PR_CURRENT.date_trans) as maxdt
	 from PR_CURRENT
	 Join people on PR_CURRENT.Auto_Card = people.Auto_Card
	 where PR_CURRENT.Flag_last = '*'  
	 and Date_depart > =  GETDATE()  
	 and people.out_date = '1900-01-01'
	 group by people.Num_Tab) lastpr on people.Num_Tab = tabn and PR_CURRENT.date_trans = maxdt
where PR_CURRENT.Flag_last = '*'  
and Date_depart > =  GETDATE()  
and people.out_date = '1900-01-01'
and Appointments.Code_appoint in (
	select distinct d1.Code_appoint
	from PR_CURRENT d1
	where (@orgID is null or @orgID = d1.id_Firm)
)
