-- Види оплати (hr_payEl)
select 
	TO_CHAR(Vo_Cd) "ID",
	Vo_cdchr "code",
	pspr.spr_nm "name",
	TO_CHAR(vo_met) "methodID",
	TO_CHAR(Vo_Cd) || ' ' || pspr.spr_nm "description",
	'1970-01-01' as "dateFrom",
	'9999-12-31' as "dateTo",
	TO_CHAR(Vo_Rnd + 1) "roundUpTo",
	TO_CHAR(case when Vo_NoClc = 1 then 0 else 1 end) "isAutoCalc",
	TO_CHAR(case when Vo_NoReClc = 1 then 0 else 1 end) "isRecalculate",
	case 
		when vo_grp = 1 and So_Tim = 0 then 'DAY' 
		when vo_grp = 1 and So_Tim <> 0 then 'HOUR' 
		when vo_grp in (6, 9) and Bo_Zar = 0 then 'DAY' 
		when vo_grp in (6, 9) and Bo_Zar <> 0 then 'HOUR' 
		else 'null'
	end "calcProportion",
	case 
		when vo_grp = 1 then 'PLAN' 
		when vo_met = 8 then 'PLAN' 
		when vo_met = 9 then 'PLAN' 
		when vo_met = 10 then 'PLAN' 
		when vo_met = 11 then 'PLAN' 
		when vo_met = 12 then 'PLAN' 
		when vo_met = 13 then 'PLAN' 
		when vo_met = 14 then 'PLAN' 
		when vo_met = 37 then 'PLAN' 
		when vo_met = 109 then 'FACT' 
		when vo_met = 110 then 'FACT' 
		when vo_met = 216 then 'PLAN' 
		when vo_met = 266 then 'FACT' 
		when vo_grp = 2 and BITAND(vo_prz, 512) <> 0 then 'FACT' 
		when vo_grp = 2 and BITAND(vo_prz, 512) = 0 then 'PLAN' 
		when Vo_PlZr = 0 then 'FACT' 
		else 'PLAN' 
	end "calcSumType",
	case 
		when Vo_Grp = 1 then 'null'
		when Vo_Grp = 2 then 'SALARY'
		when Vo_Grp = 4 and Vo_PlZr <> 0 then 'SALARY'
		when Vo_Grp = 4 and Vo_PlZr = 0 then 'SALARY'
		when Vo_RpUp = 0 then 'SALARY'
		else 'CALC' 
	end "periodType",
	TO_CHAR(Vo_Stj) dictExperienceID,
	TO_CHAR(
		case 
			when vo_grp = 5 and Ot_QtMon > 0 then Ot_QtMon
			when vo_grp = 5 and Ot_QtMon = 0 then 12
			when vo_grp = 6 and Bo_QtMon > 0 then Bo_QtMon
			when vo_grp = 6 and Bo_QtMon = 0 then 12
			when vo_grp = 9 then 2
			ELSE null
		end
	) "calcMonth",
	'base' "averageMethod",	
	'1' "typePrepayment",
	Vpl_DayAvn "prepaymentDay",
	(SELECT TO_CHAR(MAX(VoSF_Rcd)) FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.VoSFEK WHERE VoSFEK.Vo_Cd = PAYVO1.vo_cd AND VoSFEK.Vo_cfg = 0) AS "dictFundSourceID"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.PAYVO1
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.PSPR on SprSpr_Cd = 787202 and payvo1.Vo_Cd = pspr.spr_cd
inner join /*SYS_SCHEMA*/ISPRO_8_PROD_SYS.sspr on sspr.sprspr_cd = 131842 and sspr.spr_cdlng = 2 and sspr.spr_cd = payvo1.vo_met
where
	vo_cd in (
		select distinct KpuPrkz_SysOp
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1
		union 
		select distinct pdnch_cd
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.pdnch
		where pdnch_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		   or pdnch_datk >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
		union
		select distinct pdudr_cd
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.pdudr
		where pdudr_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		   or pdudr_datk >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
		union
		select distinct kpunch_cd
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpunch1
		where kpunch_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		   or kpunch_datk >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
		union
		select distinct kpuudr_cd
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuudr1
		where kpuudr_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		   or kpuudr_datk >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
		union
		select distinct kpurl_cdvo
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpurlo1
		where kpurl_cdvo <> 0
		and kpurl_datup >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
	)
