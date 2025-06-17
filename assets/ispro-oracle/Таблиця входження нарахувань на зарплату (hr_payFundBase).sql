-- Таблиця входження нарахувань на зарплату (hr_payFundBase)
with
	payTvDat as (
		select distinct PayTV_Part, PayTV_Cd, PayTV_Nmr, PayTV_CdT, PayTV_Dat
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.paytv
		where paytv_part = 2
	),
	payTvMinDat as (
		select
			p1.PayTV_Part, p1.PayTV_Cd, p1.PayTV_Nmr, p1.PayTV_CdT,
			min(p1.PayTV_Dat) as MinDat
		from payTvDat p1
		join /*FIRM_SCHEMA*/ISPRO_8_PROD.paytv t1
			on p1.PayTV_Part = t1.PayTV_Part
			and p1.PayTV_Cd = t1.PayTV_Cd
			and p1.PayTV_Nmr = t1.PayTV_Nmr
			and p1.PayTV_CdT = t1.PayTV_CdT
			and p1.PayTV_Dat > t1.PayTV_Dat
		group by p1.PayTV_Part, p1.PayTV_Cd, p1.PayTV_Nmr, p1.PayTV_CdT
	),
	payVoList as (
		select vo_cd
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.payvo1
		where vo_cd in (
			select distinct KpuPrkz_SysOp from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1
			union
			select distinct pdnch_cd from /*FIRM_SCHEMA*/ISPRO_8_PROD.pdnch
			where pdnch_datk <= DATE '1876-12-31'
			   or pdnch_datk >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
			union
			select distinct pdudr_cd from /*FIRM_SCHEMA*/ISPRO_8_PROD.pdudr
			where pdudr_datk <= DATE '1876-12-31'
			   or pdudr_datk >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
			union
			select distinct kpunch_cd from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpunch1
			where kpunch_datk <= DATE '1876-12-31'
			   or kpunch_datk >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
			union
			select distinct kpuudr_cd from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuudr1
			where kpuudr_datk <= DATE '1876-12-31'
			   or kpuudr_datk >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
			union
			select distinct kpurl_cdvo from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpurlo1
			where kpurl_cdvo <> 0
			and kpurl_datup >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
		)
	)
select
	min(t1.bookmark) "ID",
	t1.paytv_cd "payFundID",
	t1.paytv_cdv "payElID"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.paytv t1
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.payfnd f1
	on f1.payfnd_rcd = t1.paytv_cd
left join payTvDat t2
	on t2.paytv_part = t1.paytv_part
	and t2.paytv_cd = t1.paytv_cd
	and t2.paytv_nmr = t1.paytv_nmr
	and t2.paytv_cdt = t1.paytv_cdt
left join payTvMinDat t3
	on t3.PayTV_Part = t2.PayTV_Part
	and t3.PayTV_Cd = t2.PayTV_Cd
	and t3.PayTV_Nmr = t2.PayTV_Nmr
	and t3.PayTV_CdT = t2.PayTV_CdT
	and t2.PayTV_Dat = t3.MinDat
where t1.paytv_part = 2
	and t1.paytv_nmr = 33
	and t1.paytv_cdv in (select vo_cd from payVoList)
	and f1.PayFnd_Del = 0
group by t1.paytv_cd, t1.paytv_cdv
