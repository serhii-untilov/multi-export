-- Нагорода (hr_dictBonus)
select 
	code ID
	,code
	,vid.spr_nmlong name	
	,'NULL' abbr	
	,vid.spr_nmlong preamble	
	,bonusKindID	
	,bonusTypeID	
	,'1' isActive	
	,'GEN' caseType	
	,'0' isEnc
from (
	select 
		cast(row_number() over(partition BY kdrrew_vid ORDER BY kdrrew_vid, kdrrew_type) as varchar) code	
		,kdrrew_vid bonusKindID	
		,kdrrew_type bonusTypeID	
	from KdrRew
	group by kdrrew_vid, kdrrew_type
) KdrRew
left join pspr vid on vid.spr_cd = bonusKindID and vid.sprspr_cd = 681063
left join pspr typ on typ.spr_cd = bonusTypeID and vid.sprspr_cd = 681062
