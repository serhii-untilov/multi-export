-- Адреси працівників (ac_address)
select 
	a1.bookmark "ID"
	,a1.kpu_rcd "employeeID"
	,a1.kpu_rcd "employeeNumberID"
	,x1.kpu_tn "tabNum"
	,c1.kpu_cdnlp "taxCode"
	,c1.kpu_fio "fullFIO"
	,case when c1.kpu_dtroj <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '' else TO_CHAR(c1.kpu_dtroj, 'YYYY-MM-DD') end "birthDate"
	,case when kpuadr_add = 0 then TO_CHAR(a1.kpuadr_cd)
		else '' end "addressType" -- (1-������.,2-������.,3-����.)
	,a1.KpuAdr_Index "postIndex"
	,a1.KpuAdr_Cnt "countryID"
	,SprAdrCnt.SAdrCnt_Cd "countryCode"
	,CASE WHEN (KpuAdr_CntNm IS NULL OR KpuAdr_CntNm = '') THEN SprAdrCnt.SAdrCnt_Nm ELSE KpuAdr_CntNm END "countryName"
	,a1.KpuAdr_Reg "regionID"
	,SprAdrReg.SAdrReg_Cd "regionCode"
	,CASE WHEN (KpuAdr_RegNm IS NULL OR KpuAdr_RegNm = '') THEN SprAdrReg.SAdrReg_Nm ELSE KpuAdr_RegNm END "regionName"
	,a1.KpuAdr_Zone "districtID"
	,SprAdrRai.SAdrRai_Cd "districtCode"
	,CASE WHEN (KpuAdr_ZoneN IS NULL OR KpuAdr_ZoneN = '') THEN SprAdrRai.SAdrRai_Nm ELSE KpuAdr_ZoneN END "districtName"
	,a1.KpuAdr_Town "cityID"
	,SprAdrTow.SAdrTow_Cd "cityCode"
	,CASE WHEN (KpuAdr_TownN IS NULL OR KpuAdr_TownN = '') THEN SprAdrTow.SAdrTow_Nm ELSE KpuAdr_TownN END "cityName"
	,KpuAdr_Plac "cityDistrictID"
	,SprAdrNas.SAdrNas_Cd "cityDistrictCode"
	,CASE WHEN (KpuAdr_PlacN IS NULL OR KpuAdr_PlacN = '') THEN SprAdrNas.SAdrNas_Nm ELSE KpuAdr_PlacN END "cityDistrictName"
	,a1.KpuAdr_Str "streetID"
	,a1.KpuAdr_StrN "street"
	,a1.KpuAdr_House "house"
	,a1.KpuAdr_Korp "section"
	,a1.KpuAdr_Flat "apartment"
	,'' "streetType"
	,case when length(KpuAdr_S) > 0 then KpuAdr_S else (
		case when KpuAdr_Index is not null then KpuAdr_Index || ',' else '' end ||
		case when KpuAdr_CntNm is not null then KpuAdr_CntNm || ',' else '' end ||
		case when KpuAdr_RegNm is not null then KpuAdr_RegNm || ',' else '' end ||
		case when KpuAdr_ZoneN is not null then KpuAdr_ZoneN || ' ,' else '' end ||
		case when KpuAdr_TownN is not null then 'м.' || KpuAdr_TownN || ',' else '' end ||
		case when KpuAdr_PlacN is not null then KpuAdr_PlacN || ',' else '' end ||
		case when KpuAdr_StrN is not null then KpuAdr_StrN || ',' else '' end ||
		case when KpuAdr_House is not null then KpuAdr_House || ',' else '' end ||
		case when KpuAdr_Korp is not null then KpuAdr_Korp || ',' else '' end ||
		case when KpuAdr_Flat is not null then KpuAdr_Flat end
	) end as "address"
	,KpuAdr_Add "sourceType" --�������������� �������� (0-�����������,1-��������������,2-������ ���������� ���������)
	,u1.kpuudr_id "payRetentionID" --ID ����������� ���������
from /*FIRM_SCHEMA*/ISPRO_8_PROD.KpuAdr1 a1
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = a1.kpu_rcd
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 on x1.kpu_rcd = c1.kpu_rcd and x1.kpu_tnosn = 0
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.vwSAdrCnt SprAdrCnt ON SprAdrCnt.SAdrCnt_Rcd = KpuAdr_Cnt
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.vwSAdrReg SprAdrReg ON SprAdrReg.SAdrReg_Rcd = KpuAdr_Reg
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.vwSAdrRai SprAdrRai ON SprAdrRai.SAdrRai_Rcd = KpuAdr_Zone
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.vwSAdrTow SprAdrTow ON SprAdrTow.SAdrTow_Rcd = KpuAdr_Town
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.vwSAdrNas SprAdrNas ON SprAdrNas.SAdrNas_Rcd = KpuAdr_Plac
LEFT JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.vwSAdrStr SprAdrStr ON SprAdrStr.SAdrStr_Rcd = KpuAdr_Str
left join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuudr1 u1 on a1.kpuadr_add = 2 and u1.kpu_rcd = c1.kpu_rcd and a1.kpuadr_cd = u1.kpuudr_cd and u1.kpuudr_rcd = a1.kpuadr_addRcd
WHERE x1.kpu_tn < 4000000000
  AND MOD(TRUNC(Kpu_Flg / 64), 2) = 0
--  AND BITAND(c1.kpu_flg, 2) = 0
--  AND x1.kpu_tnosn = 0
and (kpuadr_add = 0 -- �������������� �������� (0-�����������,1-��������������,2-������ ���������� ���������)
		--or kpuadr_add = 1
		or kpuadr_add = 2 and u1.kpuudr_id is not null
)
