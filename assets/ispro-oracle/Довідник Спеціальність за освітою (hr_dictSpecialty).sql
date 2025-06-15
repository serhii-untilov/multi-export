-- Довідник Спеціальність за освітою (hr_dictSpecialty)
with
	spec1 as (
		select
			/*+ MATERIALIZE */ distinct o1.KpuObr_SpcCd AS cd
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuobr1 o1
		join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = o1.kpu_rcd
			/*SYSSTE_BEGIN*/
			JOIN (
				SELECT
					MAX(sysste_rcd) AS sysste_rcd
				FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
				WHERE sysste_cd = /*SYSSTE_CD*/'1500'
			) ste1 ON ste1.sysste_rcd = c1.kpuc_se
			/*SYSSTE_END*/
	)
select
	spr_cd "ID",
	spr_cd "code",
	spr_nm "name"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.pspr
Where sprspr_cd = 681003
	and exists (
		select
			null
		from
			spec1
		where
			spec1.cd = pspr.spr_cd
	)
