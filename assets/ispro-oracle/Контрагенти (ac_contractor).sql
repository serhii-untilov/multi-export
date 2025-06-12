-- Контрагенти (ac_contractor)
with contractor AS (
	select /*+ MATERIALIZE */
		distinct u1.kpuudr_cdplc "ID"
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuudr1 u1
		inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = u1.kpu_rcd
		/*SYSSTE_BEGIN*/
		JOIN (
			SELECT MAX(sysste_rcd) AS sysste_rcd
			FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
			WHERE sysste_cd = /*SYSSTE_CD*/'1500'
		) ste1 ON ste1.sysste_rcd = c1.kpuc_se
		/*SYSSTE_END*/
		where u1.kpuudr_cdplc <> 0
)
select
	p1.Ptn_Rcd "ID"
	,p1.Ptn_Cd "code"
	,case when length(p1.Ptn_CdOKPO) <> 0 then SUBSTR(p1.Ptn_CdOKPO, 0, 15) else SUBSTR(('*' || p1.Ptn_Cd || '0000000'), 0, 8) end "OKPOCode"
	,p1.Ptn_Inn "taxCode"
	,'null' "vatCode"
	,SUBSTR(p1.Ptn_NmSh, 0, 299) "name"
	,SUBSTR(p1.Ptn_Nm, 0, 299) "fullName"
	,SUBSTR(p1.Ptn_NmSh, 0, 299) "nameGen"
	,'' "nameDat"
	,SUBSTR(p1.Ptn_Nm, 0, 299) "fullNameGen"
	,'' "fullNameDat"
	,SUBSTR(p1.Ptn_Nm, 0, 299) "description"
	,case when p1.Ptn_Type = 1 then 'legalEntitie' else 'entrepreneur' end "contrType"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.ptnrk p1
join contractor on contractor.ID = p1.Ptn_Rcd
where p1.Ptn_Del = 0
