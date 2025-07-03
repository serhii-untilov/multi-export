-- Види документiв (ac_dictdockind)
select
	cast(spr_cd as varchar) ID
	,cast(spr_cd as varchar) code
	,spr_nm name
from pspr
where sprspr_cd = 513
union all
-- Тип документа про освіту
select
	cast(spr_cd + 1000 as varchar) ID
	,cast(spr_cd + 1000 as varchar) code
	,spr_nm name
from pspr
Where sprspr_cd = 681067