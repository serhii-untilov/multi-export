declare @orgID bigint = (case when /*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = /*OKPO*/), -1) end)
select 
	n1.Auto_Const_Uder ID
	,n1.pID employeeNumberID
	,n1.Code_Pay payElID
	,p1.Num_Tab tabNum
	,c1.INN taxCode
	,cast(cast(n1.FromD as date) as varchar) dateFrom
	,cast(cast((case when n1.ToD in ('1900-01-01', '2099-01-01') then '9999-12-31' else n1.ToD end) as date) as varchar) dateTo
	,Summa accrualSum
	,"Percent" accrualRate
	,coalesce(N_bank, '') bankID
	,N_lc bankAccount
	-- ,ReceiveId contractorID -- !!!
	,Summa_All debtSum
	,Summa_r remindSum
	,sn docNumber
	,case -- select * from zrp_LST_transfer
		when n1.t_trans = 1 then '1' -- Перечислениe по исполнительным листам -> Банк
		when n1.t_trans = 2 then '1' -- Перечислениe в банк -> Банк
		when n1.t_trans = 3	then '1' -- Перечислениe по договорам страхования -> Банк
		when n1.t_trans = 4	then '1' -- Перечислениe по ссуде и кредитам -> Банк
		when n1.t_trans = 5	then '1' -- Перечислениe за коммунальные услуги -> Банк
		when n1.t_trans = 6	then '3' -- Перечислениe по почте -> Пошта
		when n1.t_trans = 7	then '' -- Проводки по зарплате
		else '1' -- Банк
	end paymentMethod
from const_uder n1
inner join people p1 on p1.pID = n1.pID
inner join Card c1 on c1.Auto_Card = p1.Auto_Card
where (@orgID is null or @orgID = p1.id_Firm)