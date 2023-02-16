declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)

select PR_CURRENT.pId as ID ,
Appointments.Code_appoint as code,
Name_appoint as  name  ,
Name_appoint as  fullName,
2 AS positionType,
case when Code_struct_name= (select max(Struct_Code) from StructS where StructS.Struct_Lev = 0 and Flag_deleted=0 and (@orgID is null or id_Firm=@orgID)) 
then null 
else Code_struct_name end as parentUnitID,
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
join (select 
	 p11.Code_appoint dictid
	,p11.Name_appoint dictname
     from Appointments p11
	    join  (select max(db_id) as id, Name_appoint as  name from Appointments group by Name_appoint) grp1 on db_id = id
     where p11.Code_appoint in (
	 select distinct d1.Code_appoint 
	 from PR_CURRENT d1
  	 where (@orgID is null or @orgID = d1.id_Firm)
    )) grp on  Name_appoint = dictname
where PR_CURRENT.Flag_last = '*'  and 
Date_depart > =  GETDATE()  and 
people.out_date = '1900-01-01'
and Appointments.Code_appoint in (
	select distinct d1.Code_appoint 
	from PR_CURRENT d1
	where (@orgID is null or @orgID = d1.id_Firm)
   )