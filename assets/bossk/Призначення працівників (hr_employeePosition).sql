declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)

select PR_CURRENT.prId as ID ,
	people.Auto_Card as employeeID,
	people.Num_Tab as employeeNumberID,
	case when Code_struct_name= (select max(Struct_Code) 
								 from StructS 
								 where StructS.Struct_Lev = 0 and Flag_deleted=0 and (@orgID is null or id_Firm=@orgID)) 
	then null 
	else Code_struct_name end as departmentID,
	PR_CURRENT.pId as positionID,
	dictid as dictPositionID,
	cast(cast(PR_CURRENT.date_trans as date) as varchar)  as dateFrom,
	cast(cast((case when PR_CURRENT.Date_depart in ('1900-01-01', '2099-01-01') then '9999-12-31' else PR_CURRENT.Date_depart end) as date) as varchar) dateTo,
	PR_CURRENT.Code_Regim as workScheduleID,
	Number_w as mtCount,
	workerType = case
		when p1.Work_Code = 1  then '1' -- постійно -> Постійно [1]
		when p1.Work_Code = 2  then '1'	-- за сумісництвом внутр. -> Постійно [1]
		when p1.Work_Code = 3  then '1'	-- за сумісництвом зовн. -> Постійно [1]
		when p1.Work_Code = 4  then '1'	-- за контрактом -> Постійно [1]
		when p1.Work_Code = 5  then '1'	-- за трудовою угодою -> Постійно [1]
		when p1.Work_Code = 6  then '2'	-- тимчасово -> Тимчасово [2]
		when p1.Work_Code = 7  then '2'	-- практикант -> Тимчасово [2]
		when p1.Work_Code = 8  then ''	-- за ців-правовим договором
		when p1.Work_Code = 9  then '2'	-- Тимчасово за ШР -> Тимчасово [2]
		when p1.Work_Code = 10 then '1' -- нештатний склад -> Постійно [1]
		when p1.Work_Code = 11 then '1' -- нештатный состав (сайт) -> Постійно [1]
		when p1.Work_Code = 12 then '2' -- за сум.зовн. тимчасово -> Тимчасово [2]
		else '1' end,
	workPlace = case 
		when people.Work_Code = 1  then '1' -- постійно -> Основне [1]
		when people.Work_Code = 2 then '2' -- за сумісництвом внутр. -> Сумісництво внутрішнє [2]
		when people.Work_Code = 3  then '3' -- за сумісництвом зовн. -> Сумісництво зовнішнє [3]
		when people.Work_Code = 4  then '1' -- за контрактом -> Основне [1]
		when people.Work_Code = 5  then '1' -- за трудовою угодою -> Основне [1]
		when people.Work_Code = 6  then '1' -- тимчасово -> Основне [1]
		when people.Work_Code = 7  then '1' -- практикант -> Основне [1]
		when people.Work_Code = 8  then '4' -- за ців-правовим договором -> Поза штатом [4]
		when people.Work_Code = 9  then '1' -- Тимчасово за ШР -> Основне [1]
		when people.Work_Code = 10 then '4' -- нештатний склад -> Поза штатом [4]
		when people.Work_Code = 11 then '4' -- нештатный состав (сайт) -> Поза штатом [4]
		when people.Work_Code = 12 then '3' -- за сум.зовн. тимчасово -> Сумісництво зовнішнє [3]
		else '1' end,
	1 as contractType,
	1 as dictCategoryECBID,
	dictid as dictPositionID,
	case when Number_w is null or Number_w = 0 then Wage else  Wage end as accrualSum,
	1 as payElID
from PR_CURRENT  
Join people on PR_CURRENT.pId = people.pId
join Appointments on Appointments.Code_Appoint=PR_CURRENT.Code_Appoint
join  (select p11.Code_appoint dictid
	         ,p11.Name_appoint dictname
       from Appointments p11
	   join  (select max(db_id) as id, Name_appoint as  name from Appointments group by Name_appoint) grp1 on db_id = id
       where p11.Code_appoint in (select distinct d1.Code_appoint from PR_CURRENT d1 where (@orgID is null or @orgID = d1.id_Firm))
	   ) grp on Name_appoint = dictname
where 
people.out_date = '1900-01-01'
and (@orgID is null or @orgID = PR_CURRENT.id_Firm)