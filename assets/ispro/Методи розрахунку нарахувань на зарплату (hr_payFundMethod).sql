-- Методы расчёта фондов (hr_payFundMethod)
/*BEGIN-OF-HEAD*/
select 'ID', 'code', 'name'
union all
/*END-OF-HEAD*/
select cast(spr_cd as varchar) ID, cast(spr_cd as varchar) code, spr_nm name
from /*SYS_SCHEMA*/i711_sys.dbo.sspr
where sprspr_cd = 133659
and spr_cdlng = 2
and spr_cd in (
	select distinct payfnd_stt
	from payfnd
	where payfnd_rcd in  (
		select distinct kpuf_cdfnd
		from kpufa1
	)
)
