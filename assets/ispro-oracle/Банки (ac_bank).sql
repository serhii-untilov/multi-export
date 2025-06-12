-- Банки (ac_bank)
WITH bankList AS (
	select /*+ MATERIALIZE */
		distinct b1.bank_rcd AS "ID"
		from /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuudr1 u1
		inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = u1.kpu_rcd
		/*SYSSTE_BEGIN*/
		JOIN (
			SELECT MAX(sysste_rcd) AS sysste_rcd
			FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
			WHERE sysste_cd = /*SYSSTE_CD*/'1500'
		) ste1 ON ste1.sysste_rcd = c1.kpuc_se
		/*SYSSTE_END*/
		JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.PtnSchk s1 ON s1.ptn_rcd = u1.kpuudr_cdplc AND s1.ptnsch_rcd = u1.kpuudr_cdbank
		JOIN /*FIRM_SCHEMA*/ISPRO_8_PROD.bank b1 on b1.bank_rcd = s1.PtnSch_Bcd
)
select
	TO_CHAR(b1.bank_rcd) "ID"
	,b1.Bank_MFO "MFO"
	,b1.Bank_MFO "code"
	,b1.bank_nm "name"
	,b1.bank_nm "fullName"
	,'' "phones"
	,TRIM(coalesce(b1.Bank_MFO, ' ') || ' ' || b1.bank_nm) description
from /*FIRM_SCHEMA*/ISPRO_8_PROD.bank b1
where b1.bank_rcd in
(	
	select ID from bankList
)
