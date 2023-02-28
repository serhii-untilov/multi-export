declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select 
	p1.pid ID
	,p1.Auto_Card employeeID
	,p1.id_Firm orgID
	,cast(cast(p1.in_date as date) as varchar) dateFrom
	,cast(cast((case when p1.out_date in ('1900-01-01', '2099-01-01') then '9999-12-31' else p1.out_date end) as date) as varchar) dateTo
	,coalesce(p1.Num_Tab, '') + (case when overallNum > 1 then '.' + cast(num as varchar) else '' end) tabNum
	,coalesce(c1.INN, coalesce(c1.Passp_ser, '') + coalesce(c1.Passp_num, '')) taxCode
	,coalesce(c1.Full_Name, coalesce(Name, '') + ' ' + coalesce(Name_i, '') + ' ' + coalesce(Name_o, '')) + ' [' + coalesce(p1.Num_Tab, '') + ']' description
	,personalAccount = coalesce(u2.N_lc, '')
	,payOutID = case when N_bank is null then '' when N_bank = 0 then '' else cast(N_bank as varchar) end
from people p1
inner join Card c1 on c1.Auto_Card = p1.Auto_Card
left join (
	select u1.pID employeeNumberID, max(u1.Auto_Const_Uder) payRetentionID
	from const_uder u1
	where u1.Code_Pay in (301, 328, 363) -- виплата зарплати
		and len(rtrim(ltrim(coalesce(N_lc, '')))) > 0
	group by u1.pID
) t1 on t1.employeeNumberID = p1.pId
left join const_uder u2 on u2.Auto_Const_Uder = t1.payRetentionID
left join (
	select p2.pid,
	(	select count(*) 
		from people p3
		where p3.Num_Tab = p2.Num_Tab and p3.pid <= p2.pid
	) num
	from people p2
) p4 on p4.pid = p1.pid
left join (
	select p2.pid,
	(	select count(*) 
		from people p3
		where p3.Num_Tab = p2.Num_Tab
	) overallNum
	from people p2
) p5 on p5.pid = p1.pid
where (@orgID is null or @orgID = p1.id_Firm)
order by p1.id_Firm, p1.Num_Tab