-- Таблиця входження нарахувань на зарплату (hr_payFundBase)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)));
with 
	payTvDat (PayTV_Part, PayTV_Cd, PayTV_Nmr, PayTV_CdT, PayTV_Dat)
	as (
		select distinct PayTV_Part, PayTV_Cd, PayTV_Nmr, PayTV_CdT, PayTV_Dat
		from paytv
		where paytv_part = 2
	),
	payVoList (Vo_Cd)
	as (
		select vo_cd 
		from payvo1
		where vo_cd in (
			select distinct KpuPrkz_SysOp
			from kpuprk1
			union 
			select distinct pdnch_cd
			from pdnch
			where pdnch_datk <= '1876-12-31' or pdnch_datk >= @dateFrom
			union
			select distinct pdudr_cd
			from pdudr
			where pdudr_datk <= '1876-12-31' or pdudr_datk >= @dateFrom
			union
			select distinct kpunch_cd
			from kpunch1
			where kpunch_datk <= '1876-12-31' or kpunch_datk >= @dateFrom
			union
			select distinct kpuudr_cd
			from kpuudr1
			where kpuudr_datk <= '1876-12-31' or kpuudr_datk >= @dateFrom
			union
			select distinct kpurl_cdvo
			from kpurlo1
			where kpurl_cdvo <> 0
			and kpurl_datup >= @dateFrom
		)
	)
/*BEGIN-OF-HEAD*/
select 'ID' ID,	'payFundID' payFundID, 'payElID' payElID
union all
/*END-OF-HEAD*/
select 
	cast(min(t1.bookmark) as varchar) ID	
	,cast(t1.paytv_cd as varchar) payFundID
	,cast(t1.paytv_cdv as varchar) payElID
from paytv t1
inner join payfnd f1 on f1.payfnd_rcd = t1.paytv_cd
left join payTvDat t2 on t2.paytv_part = t1.paytv_part 
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
and (f1.PayFnd_Del = 0 
--	or exists (
--		select null
--		from KPUFA1 k1
--		where k1.KpuF_CdFnd = f1.payfnd_rcd
--		and kpuf_datup >= @dateFrom
--	)
)
group by t1.paytv_cd, t1.paytv_cdv
