-- Види документiв (ac_dictdockind)
select 
	TO_CHAR(spr_cd) "ID"
	,TO_CHAR(spr_cd) "code"
	,spr_nm "name"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr 
where sprspr_cd = 513
union all
-- Тип документа про освіту
select 
	TO_CHAR(spr_cd + 1000) "ID"
	,TO_CHAR(spr_cd + 1000) "code"
	,spr_nm "name"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr 
Where sprspr_cd = 681067