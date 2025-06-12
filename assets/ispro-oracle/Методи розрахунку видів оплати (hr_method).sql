-- Методи розрахунку видів оплати (hr_method)
select 
	spr_cd "ID", 
	spr_cd "code", 
	replace(spr_nm, ';', ' ') "name"
from /*SYS_SCHEMA*/ISPRO_8_PROD_SYS.sspr
where sprspr_cd = 131842
and spr_cdlng = 2
and spr_cd in (
	select distinct vo_met
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.payvo1
	where vo_cd in  (
		select distinct KpuPrkz_SysOp cd
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1
		union 
		select distinct pdnch_cd cd
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
)
