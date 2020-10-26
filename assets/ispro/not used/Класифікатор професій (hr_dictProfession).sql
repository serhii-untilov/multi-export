-- Класификатор профессий) (hr_dictProfession)
/*BEGIN-OF-HEAD*/
select 'ID' ID, 
	'code' code, 
	'codeZKPPTR' codeZKPPTR,
	'name' name,
	'description' description
union all
/*END-OF-HEAD*/
select 
	cast(sdolcl_rcd as varchar) ID	
	,sdolcl_cd code	
	,cast(sdolcl_zkpptr as varchar) codeZKPPTR	
	,sdolcl_nm name	
	,sdolcl_cd + ' ' + sdolcl_nm description	
from /*SYS_SCHEMA*/i711_sys.dbo.SDolCL
where sdolcl_zkpptr <> 0
and sdolcl_rcd in (
	select c1.sdolcl_rcd
	from SPRDOL d1
	inner join /*SYS_SCHEMA*/i711_sys.dbo.SDolCL c1 on 
		c1.sdolcl_zkpptr = d1.sprd_zkpptr
		and c1.sdolcl_cd = d1.sprd_klcd
		and len(d1.sprD_klCd) <> 0
		and len(d1.sprd_zkpptr) <> 0
	where sprd_prz = 0 or exists (
		select null
		from kpuprk1
		where kpuprkz_dol = SprD_Cd
	)
)
