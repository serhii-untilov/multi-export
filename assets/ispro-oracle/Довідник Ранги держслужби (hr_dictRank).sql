-- Довідник Ранги держслужби (hr_dictRank)
select 
	s1.spr_cd "ID"
	,s1.spr_cd "code"
	,s1.spr_nm "name"
from /*FIRM_SCHEMA*/dfinm001.pspr s1 
where s1.sprspr_cd = 559
