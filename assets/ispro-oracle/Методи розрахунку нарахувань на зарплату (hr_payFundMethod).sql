-- Методи розрахунку нарахувань на зарплату (hr_payFundMethod)
select 
	spr_cd "ID", 
	spr_cd "code", 
	spr_nm "name"
from /*SYS_SCHEMA*/ISPRO_8_PROD_SYS.sspr
where sprspr_cd = 133659
and spr_cdlng = 2
and spr_cd in (
	select distinct payfnd_stt
	from /*FIRM_SCHEMA*/ISPRO_8_PROD.payfnd
	where payfnd_rcd in  (
		select distinct kpuf_cdfnd
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpufa1
	)
)
