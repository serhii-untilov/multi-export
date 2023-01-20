declare @orgID bigint = (case when /*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = /*OKPO*/), -1) end)
select 
	p1.prId ID
	,p1.Auto_Card employeeID
	,n1.pid employeeNumberID
	,p1.id_Firm organizationID
	,n1.Num_Tab tabNum
	,coalesce(c1.INN, coalesce(c1.Passp_ser, '') + coalesce(c1.Passp_num, '')) taxCode
	,cast(cast(p1.Date_trans as date) as varchar) dateFrom
	-- ,case when p2.Date_trans is null then '9999-12-31' else cast(cast(p2.Date_trans as date) as varchar) end dateTo
	,cast(cast(p1.Date_depart as date) as varchar) dateTo
	,p1.Code_struct_name departmentID
	,p1.Code_Appoint dictPositionID
	,cast(cast(p1.Wage as numeric(19,2)) as varchar) accrualSum
    ,p1.Code_Regim workScheduleID
	,workerType = case
		when p1.Work_Code = 1  then '1' 	-- постійно -> Постійно [1]
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
		when p1.Work_Code = 2  then '2' -- за сумісництвом внутр. -> Сумісництво внутрішнє [2]
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
	-- ,cast(p1.Bal_Account as varchar) accountID -- !!!
--    ,description = ''
--    ,dictRankID = ''
    ,dictStaffCatID = p1.Work_Categ
    ,p1.Code_SysPay payElID
from PR_CURRENT p1
inner join Card c1 on c1.Auto_Card = p1.Auto_Card
inner join people n1 on n1.Auto_Card = p1.Auto_Card and p1.Date_trans between n1.in_date and n1.out_date
-- left join PR_CURRENT p2 on p2.Auto_Card = p1.Auto_Card and p2.prID = (
-- 	select max(p3.prID)
-- 	from PR_CURRENT p3
-- 	where p3.Auto_Card = p1.Auto_Card and p3.Date_Trans = (
-- 		select min(p4.Date_Trans)
-- 		from PR_CURRENT p4
-- 		where p4.Auto_Card = p1.Auto_Card and p3.Date_Trans > p1.Date_Trans
-- 	)
-- )
where (@orgID is null or @orgID = p1.id_Firm)
order by p1.id_Firm, n1.Num_Tab, p1.Date_trans
