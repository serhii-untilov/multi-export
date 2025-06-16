-- Контрагенти - Рахунки (ac_contrAccount)
with
	contractor AS (
		select /*+ MATERIALIZE */ distinct u1.kpuudr_cdplc "ID",
			u1.kpuudr_cdbank account
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuudr1 u1
		inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = u1.kpu_rcd
			/*SYSSTE_BEGIN*/
			JOIN (
				SELECT
					MAX(sysste_rcd) AS sysste_rcd
				FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
				WHERE sysste_cd = /*SYSSTE_CD*/ '1500'
			) ste1 ON ste1.sysste_rcd = c1.kpuc_se
			/*SYSSTE_END*/
		where
			u1.kpuudr_cdplc <> 0
	)
select
	s.bookmark "ID",
	s.Ptn_Rcd "organizationID" -- ID контрагента
,
	PtnSch_Bcd "bankID",
	case
		when length (PtnSch_Nsc) <> 0 then PtnSch_Nsc
		else '*0000000000000'
	end "code",
	case
		when length (PtnSch_Kom) = 0 then 'Розрахунковий'
		else PtnSch_Kom
	end || ' ' || PtnSch_Nsc || ' UAH (' || b.bank_nm || ')' "description"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.PtnSchk s
join /*FIRM_SCHEMA*/ISPRO_8_PROD.bank b on b.bank_rcd = s.PtnSch_Bcd
join /*FIRM_SCHEMA*/ISPRO_8_PROD.ptnrk r on r.ptn_rcd = s.ptn_rcd
join contractor on contractor.ID = r.Ptn_Rcd
	AND contractor.account = s.ptnsch_rcd
where
	r.ptn_del = 0
