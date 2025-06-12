-- Таблиця входження нарахувань на зарплату (hr_payFundBase)
with 
	payTvDat (PayTV_Part, PayTV_Cd, PayTV_Nmr, PayTV_CdT, PayTV_Dat)
	as (
		select distinct PayTV_Part, PayTV_Cd, PayTV_Nmr, PayTV_CdT, PayTV_Dat
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.paytv
		where paytv_part = 2
	),
	payVoList (Vo_Cd)
	as (
		select vo_cd 
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.payvo1
		where vo_cd in (
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
	)
select 
	min(t1.bookmark) "ID"
	,t1.paytv_cd "payFundID"
	,t1.paytv_cdv "payElID"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.paytv t1
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.payfnd f1 on f1.payfnd_rcd = t1.paytv_cd
left join /*FIRM_SCHEMA*/ISPRO_8_PROD.payTvDat t2 on t2.paytv_part = t1.paytv_part 
	and t2.paytv_cd = t1.paytv_cd
	and t2.paytv_nmr = t1.paytv_nmr
	and t2.paytv_cdt = t1.paytv_cdt
	and t2.paytv_dat = (
		select min(t3.paytv_dat)
		from payTvDat t3
		where t3.paytv_part = t1.paytv_part
			and t3.paytv_cd = t1.paytv_cd
			and t3.paytv_nmr = t1.paytv_nmr
			and t3.paytv_cdt = t1.paytv_cdt
			and t3.paytv_dat > t1.paytv_dat
	)
where t1.paytv_part = 2
	and t1.paytv_nmr in (33)
	and t1.paytv_cdv in (
		select vo_cd 
		from payVoList
	)
	and f1.PayFnd_Del = 0
group by t1.paytv_cd, t1.paytv_cdv
