-- Банки (ac_bank)
select 'ID' ID, 'MFO' MFO, 'code' code, 'name' name, 'fullName' fullName, 'phones' phones, 'description' description
union all
select distinct
	cast(b1.bank_rcd as varchar) ID
	,b1.Bank_MFO MFO
	,null code
	,b1.bank_nm name
	,b1.bank_nm fullName
	,null phones
	,coalesce(b1.Bank_MFO, '') + ' ' + b1.bank_nm description
from bank b1
where b1.bank_rcd in
(	select distinct s2.ptnsch_bcd
	from PtnSchk s2
	inner join ptnrk r1 on r1.ptn_rcd = s2.ptn_rcd
	where r1.ptn_del = 0
)


