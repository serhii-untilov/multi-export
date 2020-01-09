-- Види документiв (ac_dictdockind)
/*BEGIN-OF-HEAD*/
select 'ID' ID, 'code' code, 'name' name
union all
/*END-OF-HEAD*/
select 
	cast(spr_cd as varchar) ID
	,cast(spr_cd as varchar) code
	,spr_nm name
from pspr 
where sprspr_cd = 513
