-- Контрагенты - Счета (ac_contrAccount)
/*BEGIN-OF-HEAD*/
select 'ID' ID, 'organizationID' organizationID, 'bankID' bankID, 'code' code, 'description' description
union all
/*END-OF-HEAD*/
select 
	cast(s.bookmark as varchar) ID	
	,cast(s.Ptn_Rcd as varchar) organizationID -- ID контрагента
	,cast(PtnSch_Bcd as varchar) bankID	
	,case when len(PtnSch_Nsc) <> 0 then PtnSch_Nsc else '*0000000000000' end code	
	,case when len(PtnSch_Kom) = 0 then 'Розрахунковий' else PtnSch_Kom end + ' ' + PtnSch_Nsc + ' UAH (' + b.bank_nm + ')' description	
from PtnSchk s
inner join bank b on b.bank_rcd = s.PtnSch_Bcd
inner join ptnrk r on r.ptn_rcd = s.ptn_rcd
where r.ptn_del = 0