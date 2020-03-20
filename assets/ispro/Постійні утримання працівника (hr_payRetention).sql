-- Постійні утримання працівника (hr_payRetention)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
/*BEGIN-OF-HEAD*/
select 'ID' ID
	,'tabNum' tabNum
	,'employeeNumberID' employeeNumberID
	,'dateFrom' dateFrom, 'dateTo' dateTo, 'payElID' payElID, 'baseSum' baseSum, 'rate' rate, 'paymentMethod' paymentMethod,
	'bankID' bankID, 'employeeFamilyID' employeeFamilyID, 'debtSum' debtSum, 'remindSum' remindSum, 'dateIdxFrom' dateIdxFrom, 'docDate' docDate, 'docNumber' docNumber, 
	'contractorID' contractorID, 'contrAccountID' contrAccountID, 'personalAccount' personalAccount
union all
/*END-OF-HEAD*/
select
	cast(u1.KpuUdr_Id as varchar) ID	
	,cast(x1.kpu_tn as varchar) tabNum
	,cast(u1.kpu_rcd as varchar) employeeNumberID	
	,cast(cast(u1.kpuUdr_datn as date) as varchar) dateFrom	
	,cast(case when u1.kpuUdr_datk <= '1876-12-31' then '9999-12-31' else CAST(u1.kpuUdr_datk as DATE) end as varchar) dateTo	
	,cast(u1.kpuudr_cd as varchar) payElID	
	,cast(case when (KpuUdr_Prz & 1) <> 0 then null else cast(cast(u1.kpuUdr_Sm as numeric(19,2)) / power(10, kpuudr_mt) as numeric(19, 2)) end as varchar) baseSum	
	,cast(case when (KpuUdr_Prz & 1) = 0 then null else cast(cast(u1.kpuUdr_Sm as numeric(19, 2)) / power(10, kpuudr_mt) as numeric(19, 2)) end as varchar) rate
	,cast( case when KpuUdrPlc_Typ = 1 then 2 -- Каса
		when KpuUdrPlc_Typ = 3 then 1 -- Банк
		when KpuUdrPlc_Typ = 4 then 1 -- Сбербанк - Банк
		when KpuUdrPlc_Typ = 2 then 3 -- Пошта
		else 1 end as varchar) paymentMethod -- Банк
	,cast(s1.ptnsch_bcd as varchar) bankID	
	,case when v1.vo_met = 19 and len(KpuUdr_DatRRFio) > 0 then cast(u1.kpuudr_ID as varchar) else null end employeeFamilyID	
	,cast(cast(cast(u1.KpuUdr_Dolg as numeric(19, 2)) / 100 as numeric(19, 2)) as varchar) debtSum	
	,cast(cast(cast(u1.KpuUdr_Rest as numeric(19, 2)) / 100 as numeric(19, 2)) as varchar) remindSum	
	,cast(case when u1.KpuUdr_Idx <= '1876-12-31' then null else u1.KpuUdr_Idx end as varchar) dateIdxFrom	
	,cast(cast(case when u1.kpuudr_dtpr <= '1876-12-31' then null else u1.kpuudr_dtpr end as date) as varchar) docDate	
	,case when len(u1.kpuudr_cdpr) = 0 then null else u1.kpuudr_cdpr end docNumber	
	,cast(k1.Ptn_Rcd as varchar) contractorID	
	,cast(s1.bookmark as varchar) contrAccountID	
	,case when len(kpuudr_ls) = 0 then null else kpuudr_ls end personalAccount
from KPUUDR1 u1
inner join kpuc1 c1 on c1.kpu_rcd = u1.kpu_rcd
inner join kpux x1 on x1.kpu_rcd = u1.kpu_rcd
inner join payvo1 v1 on v1.vo_cd = u1.kpuudr_cd
left join PtnSchk s1 on s1.ptn_rcd = u1.kpuudr_cdplc and s1.ptnsch_rcd = u1.kpuudr_cdbank
left join PtnRk k1 on k1.Ptn_Rcd = u1.kpuudr_cdplc
where (c1.kpu_flg & 2) = 0
and (kpuudr_datk <= '1876-12-31' or kpuudr_datk >= @dateFrom)