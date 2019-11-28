-- Таблиця входження видiв оплати (hr_payElEntry)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)));
with 
	payTvDat (PayTV_Part, PayTV_Cd, PayTV_Nmr, PayTV_CdT, PayTV_Dat)
	as (
		select distinct PayTV_Part, PayTV_Cd, PayTV_Nmr, PayTV_CdT, PayTV_Dat
		from paytv
		where paytv_part = 1
	),
	payVoList (Vo_Cd)
	as (
		select vo_cd 
		from payvo1
		where vo_cd in (
			select distinct pdnch_cd
			from pdnch
			where pdnch_datk = '1876-12-31' or pdnch_datk >= @dateFrom
			union
			select distinct pdudr_cd
			from pdudr
			where pdudr_datk = '1876-12-31' or pdudr_datk >= @dateFrom
			union
			select distinct kpunch_cd
			from kpunch1
			where kpunch_datk = '1876-12-31' or kpunch_datk >= @dateFrom
			union
			select distinct kpuudr_cd
			from kpuudr1
			where kpuudr_datk = '1876-12-31' or kpuudr_datk >= @dateFrom
			union
			select distinct kpurl_cdvo
			from kpurlo1
			where kpurl_cdvo <> 0
			and kpurl_datup >= @dateFrom
		)
	)
select 'ID' ID, 'payElID' payElID, 'payElBaseID' payElBaseID, 'dateFrom' dateFrom, 'dateTo' dateTo, 'entryType'	entryType
union all
select cast(ID as varchar) ID, cast(payElID as varchar) payElID, cast(payElBaseID as varchar) payElBaseID, 
	cast(cast(dateFrom as date) as varchar), 
	cast(cast(dateTo as date) as varchar), 
	entryType
from
(	
	select 
		cast(min(t1.bookmark) as varchar) ID	
		,cast(t1.paytv_cd as varchar) payElID	
		,cast(t1.paytv_cdv as varchar) payElBaseID	
		,cast(cast(t1.paytv_dat as date) as varchar) dateFrom	
		,cast(cast(case when t2.paytv_dat is null then '9999-12-31' else t2.paytv_dat - 1 end as date) as varchar) dateTo	
		,case when t1.paytv_nmr = 34 then 'TIME' else 'SUM' end entryType
	from paytv t1
	inner join payvo1 v1 on v1.vo_cd = t1.paytv_cd
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
	where t1.paytv_part = 1
		and t1.paytv_nmr in (1,2, 3, 4 ,18, 19, 20, 32, 33, 34, 53)
		and t1.paytv_cd in (
			select vo_cd 
			from payVoList
		)
		and t1.paytv_cdv in (
			select vo_cd 
			from payVoList
		)
		and not (v1.vo_met = 72 and t1.paytv_nmr <> 33)
		and vo_met not in (42)
	group by t1.paytv_cd, t1.paytv_cdv, t1.paytv_dat, t2.paytv_dat
		,case when t1.paytv_nmr = 34 then 'TIME' else 'SUM' end

) t2
where t2.dateTo >= @dateFrom	
