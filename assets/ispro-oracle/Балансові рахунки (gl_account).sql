select
	cast(sprpls_rcd as varchar(20)) ID
	,sprpls_sch code
	,sprpls_nm name
	,sprpls_sch || ' ' || sprpls_nm description
from /*FIRM_SCHEMA*/dfirm001.sprpls p1
where sprpls_rcd in (
	select distinct KpuPrkz_Sch
	from /*FIRM_SCHEMA*/dfirm001.kpuprk1
	where KpuPrkz_Sch <> 0
)
