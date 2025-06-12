-- Таблиця входження видів оплати у види доходу ПДФО (hr_payElTaxIndivid)
select 
	paytv.bookmark "ID"
	,paytv_cdt "taxIndividID"
	,paytv_cdv "payElID"
--	,vdx.spr_nm dictTaxIndividName
--	,v2.spr_nm payElName
from /*FIRM_SCHEMA*/ISPRO_8_PROD.paytv
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr vdx on vdx.sprspr_cd = 133666 and vdx.spr_cd = paytv_cdt
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.PAYVO1 v1 on v1.vo_cd = paytv.paytv_cdv
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.PSPR v2 on v2.SprSpr_Cd = 787202 and v2.spr_cd = v1.Vo_Cd
where paytv_part = 3
and paytv_cd = 207
and paytv_nmr = 33
