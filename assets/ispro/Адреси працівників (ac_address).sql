-- Адреси працівників (ac_address)
select 
	cast(a1.bookmark as varchar) ID	
	,cast(a1.kpu_rcd as varchar) employeeID
	,cast(a1.kpu_rcd as varchar) employeeNumberID
	,cast(x1.kpu_tn as varchar) tabNum
	,c1.kpu_cdnlp taxCode
	,c1.kpu_fio fullFIO
	,case when c1.kpu_dtroj <= '1876-12-31' then '' else cast(cast(c1.kpu_dtroj as date) as varchar) end birthDate 
	,case when kpuadr_add = 0 then cast(a1.kpuadr_cd as varchar) 
		else 'NULL' end addressType -- (1-Пропис.,2-Прожив.,3-Рожд.)
	,a1.KpuAdr_Index postIndex	
	,cast(a1.KpuAdr_Cnt as varchar) countryID
	,SprAdrCnt.SAdrCnt_Cd countryCode
	,(CASE WHEN (KpuAdr_CntNm IS NULL OR KpuAdr_CntNm = '') THEN SprAdrCnt.SAdrCnt_Nm ELSE KpuAdr_CntNm END) countryName
	,cast(a1.KpuAdr_Reg as varchar) regionID	
	,SprAdrReg.SAdrReg_Cd regionCode
	,(CASE WHEN (KpuAdr_RegNm IS NULL OR KpuAdr_RegNm = '') THEN SprAdrReg.SAdrReg_Nm ELSE KpuAdr_RegNm END) regionName
	,cast(a1.KpuAdr_Zone as varchar) districtID
	,SprAdrRai.SAdrRai_Cd districtCode
	,(CASE WHEN (KpuAdr_ZoneN IS NULL OR KpuAdr_ZoneN = '') THEN SprAdrRai.SAdrRai_Nm ELSE KpuAdr_ZoneN END) districtName
	,cast(a1.KpuAdr_Town as varchar) cityID	
	,SprAdrTow.SAdrTow_Cd cityCode
	,(CASE WHEN (KpuAdr_TownN IS NULL OR KpuAdr_TownN = '') THEN SprAdrTow.SAdrTow_Nm ELSE KpuAdr_TownN END) cityName
	,cast(KpuAdr_Plac as varchar) cityDistrictID
	,SprAdrNas.SAdrNas_Cd cityDistrictCode
	,(CASE WHEN (KpuAdr_PlacN IS NULL OR KpuAdr_PlacN = '') THEN SprAdrNas.SAdrNas_Nm ELSE KpuAdr_PlacN END) cityDistrictName
	,cast(a1.KpuAdr_Str as varchar) streetID
	,a1.KpuAdr_StrN street	
	,a1.KpuAdr_House house	
	,a1.KpuAdr_Korp section	
	,a1.KpuAdr_Flat apartment	
	,'' streetType
	,case when len(KpuAdr_S) > 0 then KpuAdr_S else (
		case when KpuAdr_Index is not null then KpuAdr_Index + ',' else '' end +
		case when KpuAdr_CntNm is not null then KpuAdr_CntNm + ',' else '' end +
		case when KpuAdr_RegNm is not null then KpuAdr_RegNm + ',' else '' end +
		case when KpuAdr_ZoneN is not null then KpuAdr_ZoneN + ' ,' else '' end +
		case when KpuAdr_TownN is not null then 'м.' + KpuAdr_TownN + ',' else '' end +
		case when KpuAdr_PlacN is not null then KpuAdr_PlacN + ',' else '' end +
		case when KpuAdr_StrN is not null then KpuAdr_StrN + ',' else '' end +
		case when KpuAdr_House is not null then KpuAdr_House + ',' else '' end +
		case when KpuAdr_Korp is not null then KpuAdr_Korp + ',' else '' end +
		case when KpuAdr_Flat is not null then  KpuAdr_Flat end
	) end as "address"
	,KpuAdr_Add sourceType --Дополнительные признаки (0-стандартный,1-дополнительный,2-адреса постоянных удержаний)
	,u1.kpuudr_id payRetentionID --ID постоянного удержания
from KpuAdr1 a1
inner join kpuc1 c1 on c1.kpu_rcd = a1.kpu_rcd
inner join kpux x1 on x1.kpu_rcd = c1.kpu_rcd and x1.kpu_tnosn = 0
LEFT JOIN /*FIRM_SCHEMA*/vwSAdrCnt SprAdrCnt ON SprAdrCnt.SAdrCnt_Rcd = KpuAdr_Cnt
LEFT JOIN /*FIRM_SCHEMA*/vwSAdrReg SprAdrReg ON SprAdrReg.SAdrReg_Rcd = KpuAdr_Reg
LEFT JOIN /*FIRM_SCHEMA*/vwSAdrRai SprAdrRai ON SprAdrRai.SAdrRai_Rcd = KpuAdr_Zone
LEFT JOIN /*FIRM_SCHEMA*/vwSAdrTow SprAdrTow ON SprAdrTow.SAdrTow_Rcd = KpuAdr_Town
LEFT JOIN /*FIRM_SCHEMA*/vwSAdrNas SprAdrNas ON SprAdrNas.SAdrNas_Rcd = KpuAdr_Plac
LEFT JOIN /*FIRM_SCHEMA*/vwSAdrStr SprAdrStr ON SprAdrStr.SAdrStr_Rcd = KpuAdr_Str
left join kpuudr1 u1 on a1.kpuadr_add = 2 and u1.kpu_rcd = c1.kpu_rcd and a1.kpuadr_cd = u1.kpuudr_cd and u1.kpuudr_rcd = a1.kpuadr_addRcd
where (kpuadr_add = 0 -- Дополнительные признаки (0-стандартный,1-дополнительный,2-адреса постоянных удержаний)
		--or kpuadr_add = 1
		or kpuadr_add = 2 and u1.kpuudr_id is not null
);
