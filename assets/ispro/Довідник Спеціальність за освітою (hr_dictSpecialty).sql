-- Довідник Спеціальність за освітою (hr_dictSpecialty)
select 
	cast(spr_cd as varchar) ID
	,cast(spr_cd as varchar) code
	,spr_nm name
from pspr 
Where sprspr_cd = 681003