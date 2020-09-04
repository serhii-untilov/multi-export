-- Довідник Тарифних розрядів (hr_dictTarifCoeff)
select cast(raz as varchar) ID
	,cast(raz as varchar)code
	,cast(raz as varchar) name
from (
	select distinct kpuprkz_raz raz
	from kpuprk1
	where kpuprkz_raz <> 0
) t1