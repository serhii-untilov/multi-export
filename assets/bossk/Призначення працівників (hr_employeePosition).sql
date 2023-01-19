declare @orgID bigint = (case when /*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = /*OKPO*/), -1) end)
select 
	cast(p1.prId as varchar) ID
	,cast(p1.Auto_Card as varchar) employeeID
	,cast(n1.pid as varchar) employeeNumberID
	,cast(p1.id_Firm as varchar) organizationID
	,cast(n1.Num_Tab as varchar) tabNum
	,coalesce(c1.INN, coalesce(c1.Passp_ser, '') + coalesce(c1.Passp_num, '')) taxCode
	,cast(cast(p1.Date_trans as date) as varchar) dateFrom
	-- ,case when p2.Date_trans is null then '9999-12-31' else cast(cast(p2.Date_trans as date) as varchar) end dateTo
	,cast(cast(p1.Date_depart as date) as varchar) dateTo
	,cast(p1.Code_struct_name as varchar) departmentID
	,cast(p1.Code_Appoint as varchar) dictPositionID
	,cast(cast(p1.Wage as numeric(19,2)) as varchar) accrualSum
    ,cast(p1.Code_Regim as varchar) workScheduleID
--    ,workerType = ''
    ,cast(p1.Number_w as varchar) mtCount
--    ,description = ''
--    ,dictRankID = ''
--    ,dictStaffCatID = ''
    ,cast(p1.Code_SysPay as varchar) payElID
--	, * 
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