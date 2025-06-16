-- Класифікатор професій (hr_dictProfession)
select
	sdolcl_rcd "ID",
	sdolcl_cd "code",
	sdolcl_zkpptr "codeZKPPTR",
	sdolcl_nm "name",
	sdolcl_cd || ' ' || sdolcl_nm "description"
from /*SYS_SCHEMA*/ISPRO_8_PROD_SYS.SDolCL
where sdolcl_zkpptr <> 0
	and sdolcl_rcd in (
		select
			c1.sdolcl_rcd
		from /*SYS_SCHEMA*/ISPRO_8_PROD_SYS.SPRDOL d1
		inner join /*SYS_SCHEMA*/ISPRO_8_PROD_SYS.SDolCL c1 on c1.sdolcl_zkpptr = d1.sprd_zkpptr
			and c1.sdolcl_cd = d1.sprd_klcd
			and length (d1.sprD_klCd) <> 0
			and length (d1.sprd_zkpptr) <> 0
		where
			sprd_prz = 0
			or exists (
				select
					null
				from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuprk1
				where kpuprkz_dol = SprD_Cd
			)
	)
