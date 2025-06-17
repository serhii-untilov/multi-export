-- Довідник Тарифних розрядів (hr_dictTarifCoeff)
select
	raz "ID",
	raz "code",
	raz "name"
from
	(
		select distinct
			p1.kpuprkz_raz raz
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1 p1
		where p1.kpuprkz_raz <> 0
	) t1
