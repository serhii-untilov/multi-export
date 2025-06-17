-- Таблиця входження видiв оплати (hr_payElEntry)
with
	payTvDat as (
		select distinct PayTV_Part, PayTV_Cd, PayTV_Nmr, PayTV_CdT, PayTV_Dat
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.paytv
		where paytv_part = 1
	),
	payTvMinDat as (
		select
			p1.PayTV_Part, p1.PayTV_Cd, p1.PayTV_Nmr, p1.PayTV_CdT,
			p1.PayTV_Dat as prevDat,
			min(p2.PayTV_Dat) as nextDat
		from payTvDat p1
		left join payTvDat p2
			on p1.PayTV_Part = p2.PayTV_Part
			and p1.PayTV_Cd = p2.PayTV_Cd
			and p1.PayTV_Nmr = p2.PayTV_Nmr
			and p1.PayTV_CdT = p2.PayTV_CdT
			and p2.PayTV_Dat > p1.PayTV_Dat
		group by p1.PayTV_Part, p1.PayTV_Cd, p1.PayTV_Nmr, p1.PayTV_CdT, p1.PayTV_Dat
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
select ID, payElID, payElBaseID, dateFrom, dateTo, entryType
from (
	select
		min(t1.bookmark) ID,
		t1.paytv_cd as payElID,
		t1.paytv_cdv as payElBaseID,
		TO_CHAR(t1.paytv_dat, 'YYYY-MM-DD') as dateFrom,
		TO_CHAR(n.nextDat - 1, 'YYYY-MM-DD') as dateTo,
		case when t1.paytv_nmr = 34 then 'TIME' else 'SUM' end as entryType
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.paytv t1
	inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.payvo1 v1 on v1.vo_cd = t1.paytv_cd
	left join payTvMinDat n
		on t1.paytv_part = n.PayTV_Part
		and t1.paytv_cd = n.PayTV_Cd
		and t1.paytv_nmr = n.PayTV_Nmr
		and t1.paytv_cdt = n.PayTV_CdT
		and t1.paytv_dat = n.prevDat
	where t1.paytv_part = 1
		and t1.paytv_nmr in (1, 2, 3, 4, 18, 19, 20, 32, 33, 34, 53)
		and t1.paytv_cd in (select vo_cd from payVoList)
		and t1.paytv_cdv in (select vo_cd from payVoList)
		and not (v1.vo_met = 72 and t1.paytv_nmr <> 33)
		and v1.vo_met not in (42)
	group by
		t1.paytv_cd, t1.paytv_cdv, t1.paytv_dat, n.nextDat,
		case when t1.paytv_nmr = 34 then 'TIME' else 'SUM' end
) t2
where TO_DATE(t2.dateTo, 'YYYY-MM-DD') >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
