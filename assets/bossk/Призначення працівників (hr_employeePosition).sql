--призначення
declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)

select PR_CURRENT.prId as ID ,
people.Auto_Card as employeeID,
people.Num_Tab as employeeNumberID,
case when Code_struct_name=43 then 7005446 else Code_struct_name end as departmentID,
PR_CURRENT.pId as positionID,
dictid as dictPositionID,
cast(cast(PR_CURRENT.date_trans as date) as varchar)  as dateFrom,
cast(cast((case when PR_CURRENT.Date_depart in ('1900-01-01', '2099-01-01') then '9999-12-31' else PR_CURRENT.Date_depart end) as date) as varchar) dateTo,
PR_CURRENT.Code_Regim as workScheduleID,
Number_w as mtCount,
1 as workerType,
people.sovm as workPlace,
1 as contractType,
1 as dictCategoryECBID,
dictid as dictPositionID,
case when Number_w is null or Number_w = 0 then Wage else  Wage end as accrualSum,
1 as payElID
from PR_CURRENT  
Join people on PR_CURRENT.pId = people.pId
join Appointments on Appointments.Code_Appoint=PR_CURRENT.Code_Appoint
join  (select 
	 p11.Code_appoint dictid
	,p11.Name_appoint dictname
     from Appointments p11
	    join  (select max(db_id) as id, Name_appoint as  name from Appointments group by Name_appoint) grp1 on db_id = id
     where p11.Code_appoint in (
	 select distinct d1.Code_appoint 
	 from PR_CURRENT d1
  	 where (@orgID is null or @orgID = d1.id_Firm)
    )) grp on Name_appoint = dictname
where 
people.out_date = '1900-01-01'
and (@orgID is null or @orgID = PR_CURRENT.id_Firm)