-- Постійні нарахуванна та утримання по організіції (hr_payPerm)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
/*
select 'ID' ID, 'payType' payType, 'payElID' payElID, 'dateFrom' dateFrom, 'dateTo' dateTo, 'paySum' paySum, 'rate' rate, 
	'dictFundSourceID' dictFundSourceID, 'accountID' accountID
union all
*/
select 
	cast(pdnch_rcd as varchar) ID
	,'PAYMENT' payType
	,cast(pdnch_cd as varchar) payElID
	,cast(cast(pdnch_datn as date) as varchar) dateFrom
	,cast(cast( case when pdnch_datk = '1876-12-31' then '9999-12-31' else pdnch_datk end as date) as varchar) dateTo
	,cast(case when (pdnch_prz & 2) = 0 then pdnch_sm / power(10, pdnch_mt) else 0 end as varchar) paySum 
	,cast(case when (pdnch_prz & 2) <> 0 then pdnch_sm / power(10, pdnch_mt) else 0 end as varchar) rate
	,cast( case when pdnch_sf = 0 then null else pdnch_sf end as varchar) dictFundSourceID
	,cast( case when pdnch_sch = 0 then null else pdnch_sch end as varchar) accountID
from PdNch
where PdNch_Del = 0 and (pdnch_datk = '1876-12-31' or pdnch_datk >= @dateFrom)
union all
select 
	cast(65535 + pdudr_rcd as varchar) ID
	,'OFFTAKE' payType
	,cast(pdudr_cd as varchar) payElID
	,cast(cast(pdudr_datn as date) as varchar) dateFrom
	,cast(cast(case when pdudr_datk = '1876-12-31' then '9999-12-31' else pdudr_datk end as date) as varchar) dateTo
	,cast(case when (pdudr_prz & 2) = 0 then pdudr_sm / power(10, pdudr_mt) else 0 end as varchar) paySum
	,cast(case when (pdudr_prz & 2) <> 0 then pdudr_sm / power(10, pdudr_mt) else 0 end as varchar) rate
	,cast(case when pdudr_sf = 0 then null else pdudr_sf end as varchar) dictFundSourceID
	,null accountID
from pdudr
where PdUdr_Del = 0 and (pdudr_datk = '1876-12-31' or pdudr_datk >= @dateFrom)