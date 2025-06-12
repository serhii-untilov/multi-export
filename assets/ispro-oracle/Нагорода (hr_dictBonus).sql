-- Нагорода (hr_dictBonus)
select 
	code "ID"
	,code "code"
	,vid.spr_nmlong "name"	
	,'null' "abbr"	
	,vid.spr_nmlong "preamble"	
	,bonusKindID "bonusKindID"
	,bonusTypeID "bonusTypeID"
	,'1' "isActive"	
	,'GEN' "caseType"	
	,'0' "isEnc"
from (
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY kdrrew_vid, kdrrew_type ORDER BY kdrrew_vid, kdrrew_type) AS code,
		kdrrew_vid AS bonusKindID,
		kdrrew_type AS bonusTypeID
	FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.KdrRew
GROUP BY kdrrew_vid, kdrrew_type
) KdrRew
left join /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr vid on vid.spr_cd = bonusKindID and vid.sprspr_cd = 681063
left join /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr typ on typ.spr_cd = bonusTypeID and vid.sprspr_cd = 681062
