-- Види документiв (ac_dictdockind)
/*
select 'ID' ID, 'code' code, 'name' name
union all
*/
select 
	cast(spr_cd as varchar) ID
	,cast(spr_cd as varchar) code
	,spr_nm name
from pspr 
where sprspr_cd = 513
