select 
		row_number() over(ORDER BY c1.kpu_rcd) AS "п/н"
		,c1.kpu_cdnlp AS "РНОКПП" --taxCode
		,c1.kpu_rcd AS "Повний ПІБ" --fullFIO
		,case when c1.kpu_dtroj <= '1876-12-31' then '' else cast(cast(c1.kpu_dtroj as date) as varchar) end AS "Дата народження" 
		--,case when kpuadr_cd = 1 then '2' else '3' end AS "Тип адреси" --contactTypeID	
		,case when kpuadr_cd = 1 then 'legalAddr' else 'actualAddr' end AS "Тип адреси" --contactTypeCode
		,case when len(KpuAdr_S) > 0 then KpuAdr_S else (
			case when KpuAdr_Index is not null then KpuAdr_Index + ',' else '' end +
			case when KpuAdr_CntNm is not null then KpuAdr_CntNm + ',' else '' end +
			case when KpuAdr_RegNm is not null then KpuAdr_RegNm + ',' else '' end +
			case when KpuAdr_ZoneN is not null then KpuAdr_ZoneN + ' ,' else '' end +
			case when KpuAdr_TownN is not null then 'ì.' + KpuAdr_TownN + ',' else '' end +
			case when KpuAdr_PlacN is not null then KpuAdr_PlacN + ',' else '' end +
			case when KpuAdr_StrN is not null then KpuAdr_StrN + ',' else '' end +
			case when KpuAdr_House is not null then KpuAdr_House + ',' else '' end +
			case when KpuAdr_Korp is not null then KpuAdr_Korp + ',' else '' end +
			case when KpuAdr_Flat is not null then  KpuAdr_Flat end
		) end AS "Адреса"
		,c1.kpu_rcd  AS "Зовнішній код"
	from KpuAdr1 a1
	inner join kpuc1 c1 on c1.kpu_rcd = a1.kpu_rcd
	inner join kpux x1 on x1.kpu_rcd = c1.kpu_rcd and x1.kpu_tnosn = 0
	where kpuadr_cd in (1,2)
	