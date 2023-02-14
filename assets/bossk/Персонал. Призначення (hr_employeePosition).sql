declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)

select PR_CURRENT.pId as ID ,
people.Auto_Card as employeeID,
people.Num_Tab as employeeNumberID,
case when Code_struct_name=43 then 7005446 else Code_struct_name end as departmentID,
PR_CURRENT.pId as positionID,
dictid as dictPositionID,
cast(cast(PR_CURRENT.date_trans as date) as varchar)  as dateFrom,
PR_CURRENT.Code_Regim as workScheduleID,
Number_w as mtCount,
1 as workerType,
people.sovm as workPlace,
1 as contractType,
1 as dictCategoryECBID,
dictid as dictPositionID,
case when Number_w is null or Number_w = 0 then Wage else  Wage end as accrualSum,
1 as payElID
from Appointments 
join PR_CURRENT on Appointments.Code_Appoint=PR_CURRENT.Code_Appoint
Join people on PR_CURRENT.pId = people.pId
join  (select max(db_id) as dictid, Name_appoint as  dictname from Appointments group by Name_appoint) grp on  Name_appoint = dictname
join (select  people.Num_Tab as tabn, max(PR_CURRENT.date_trans) as maxdt
	from PR_CURRENT
	Join people on PR_CURRENT.Auto_Card = people.Auto_Card
	where PR_CURRENT.Flag_last = '*'  
	and Date_depart > =  GETDATE()  
	and people.out_date = '1900-01-01 00:00:00.000'
	group by people.Num_Tab) lastpr on people.Num_Tab = tabn and PR_CURRENT.date_trans = maxdt
where PR_CURRENT.Flag_last = '*'  
and Date_depart > =  GETDATE()  
and people.out_date = '1900-01-01 00:00:00.000'
and (@orgID is null or @orgID = PR_CURRENT.id_Firm)





