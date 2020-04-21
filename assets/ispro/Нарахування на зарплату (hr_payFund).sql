-- Нарахування на зарплату (hr_payFund)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
/*BEGIN-OF-HEAD*/
select 'ID' ID, 'code' code, 'name' name, 'dateFrom' dateFrom, 'dateTo' dateTo, 'calcPeriod' calcPeriod, 'sequence' sequence, 'isAutoCalc' isAutoCalc, 
	'isRecalculate' isRecalculate, 'payFundMethodID ' payFundMethodID , 'typeTaxECBID' typeTaxECBID, 'description' description, 'entryOperationID' entryOperationID
union all
/*END-OF-HEAD*/
select
	cast(payfnd_rcd as varchar) ID
	,payfnd_cd code
	,pspr.spr_nm name
	,cast(cast(payfnd_datn as date) as varchar) dateFrom
	,cast(cast(case when payfnd_datk <= '1876-12-31' then '9999-12-31' else payfnd_datk end as date) as varchar) dateTo
	,'SALARY' calcPeriod -- !!!
	,cast(case when payfnd_stt = 16 then floor(payfnd_limit) else 0 end as varchar) sequence
	,cast(case when payfnd_noclc = 0 then 1 else 0 end as varchar) isAutoCalc
	,cast(case when payfnd_noreclc = 0 then 1 else 0 end as varchar) isRecalculate
	,cast(payfnd_stt as varchar) payFundMethodID
	,null typeTaxECBID
	,payfnd_cd + ' ' + pspr.spr_nm description
	,null entryOperationID
from PayFnd f1
inner join PSPR on pspr.SprSpr_Cd = 133644 and pspr.Spr_Cd = f1.payfnd_rcd
where PayFnd_Del = 0 
--	or exists (
--		select null
--		from KPUFA1 k1
--		where k1.KpuF_CdFnd = f1.payfnd_rcd
--		and kpuf_datup >= @dateFrom
--	)