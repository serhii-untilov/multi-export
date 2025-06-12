-- Таблиця входження видів оплати у види доходу ПДФО (hr_payElTaxIndivid)
/*BEGIN-OF-HEAD*/
select 
	'ID' ID
	,'taxIndividID' taxIndividID
	,'payElID' payElID
union all
/*END-OF-HEAD*/
select 
	cast(paytv.bookmark as varchar) ID
	,cast(paytv_cdt as varchar) taxIndividID
	,cast(paytv_cdv as varchar) payElID
--	,vdx.spr_nm dictTaxIndividName
--	,v2.spr_nm payElName
from paytv
inner join pspr vdx on vdx.sprspr_cd = 133666 and vdx.spr_cd = paytv_cdt
inner join PAYVO1 v1 on v1.vo_cd = paytv.paytv_cdv
inner join PSPR v2 on v2.SprSpr_Cd = 787202 and v2.spr_cd = v1.Vo_Cd
where paytv_part = 3
and paytv_cd = 207
and paytv_nmr = 33
