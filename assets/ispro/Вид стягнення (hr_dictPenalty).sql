-- Вид стягнення (hr_dictPenalty)
select 
	s1.spr_cd ID	
	,s1.spr_cd code	
	,s1.spr_nm name	
	,'' idxNum
from pspr s1 
where s1.sprspr_cd = 680972
