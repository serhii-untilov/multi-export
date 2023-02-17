declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select 
	p1.prId ID
	,p1.Auto_Card employeeID
	,n1.pid employeeNumberID
	,p1.id_Firm organizationID
	,n1.Num_Tab tabNum
	,coalesce(c1.INN, coalesce(c1.Passp_ser, '') + coalesce(c1.Passp_num, '')) taxCode
	,cast(cast(p1.Date_trans as date) as varchar) dateFrom
	,cast(cast((case when p1.Date_depart in ('1900-01-01', '2099-01-01') then '9999-12-31' else p1.Date_depart end) as date) as varchar) dateTo
	-- ,p1.Code_struct_name departmentID0
	,case when Code_struct_name = (
			select max(Struct_Code)
			from StructS
			where StructS.Struct_Lev = 0
				and Flag_deleted = 0
				and (@orgID is null or id_Firm = @orgID)
			)
		then ''
		else Code_struct_name 
		end as departmentID
	,p1.pId as positionID
	,dictid as dictPositionID
	,cast(cast(p1.Wage as numeric(19,2)) as varchar) accrualSum
    ,p1.Code_Regim workScheduleID
	,workerType = case
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
		else '1' end 
	,workPlace = case 
		when p1.Work_Code = 1  then '1' -- постійно -> Основне [1]
		when p1.Work_Code = 2 then '2' -- за сумісництвом внутр. -> Сумісництво внутрішнє [2]
		when p1.Work_Code = 3  then '3' -- за сумісництвом зовн. -> Сумісництво зовнішнє [3]
		when p1.Work_Code = 4  then '1' -- за контрактом -> Основне [1]
		when p1.Work_Code = 5  then '1' -- за трудовою угодою -> Основне [1]
		when p1.Work_Code = 6  then '1' -- тимчасово -> Основне [1]
		when p1.Work_Code = 7  then '1' -- практикант -> Основне [1]
		when p1.Work_Code = 8  then '4' -- за ців-правовим договором -> Поза штатом [4]
		when p1.Work_Code = 9  then '1' -- Тимчасово за ШР -> Основне [1]
		when p1.Work_Code = 10 then '4' -- нештатний склад -> Поза штатом [4]
		when p1.Work_Code = 11 then '4' -- нештатный состав (сайт) -> Поза штатом [4]
		when p1.Work_Code = 12 then '3' -- за сум.зовн. тимчасово -> Сумісництво зовнішнє [3]
		else '1' end
    ,p1.Number_w mtCount
    ,case when p1.Work_Categ is null or p1.Work_Categ = 0 then '' else cast(p1.Work_Categ as varchar) end dictStaffCatID
    ,p1.Code_SysPay payElID
	,'1' as contractType
	,'1' as dictCategoryECBID
from PR_CURRENT p1
inner join Card c1 on c1.Auto_Card = p1.Auto_Card
inner join people n1 on n1.Auto_Card = p1.Auto_Card and p1.Date_trans between n1.in_date and n1.out_date
left join StructS s1 on s1.Struct_Code = p1.Code_struct_name
join Appointments on Appointments.Code_Appoint=p1.Code_Appoint
join  (
	select p11.Code_appoint dictid, p11.Name_appoint dictname
    from Appointments p11
	join (
		select max(db_id) id, Name_appoint name 
		from Appointments 
		group by Name_appoint
	) grp1 on db_id = id
    where p11.Code_appoint in (
		select distinct d1.Code_appoint 
		from PR_CURRENT d1 
		where (@orgID is null or @orgID = d1.id_Firm)
	)
) grp on Name_appoint = dictname
where (@orgID is null or @orgID = p1.id_Firm)
-- people.out_date = '1900-01-01'
-- and n1.sovm <> p1.Work_Code
order by p1.id_Firm, n1.Num_Tab, p1.Date_trans