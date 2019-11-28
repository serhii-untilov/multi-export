-- Методи розрахунку (hr_method)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
select 'ID', 'code', 'name'
union all
select cast(spr_cd as varchar) ID, cast(spr_cd as varchar) code, replace(spr_nm, ';', ' ') name
from i711_sys.dbo.sspr
where sprspr_cd = 131842
and spr_cdlng = 2
and spr_cd in (
	select distinct vo_met
	from payvo1
	where vo_cd in  (
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
