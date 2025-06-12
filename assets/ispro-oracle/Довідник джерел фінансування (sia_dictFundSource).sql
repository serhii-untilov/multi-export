select 
	paysf_rcd "ID",
	paysf_cd "code",
	paysf_nm "name",	
	case when paysf_rcdpar = 0 then '' else TO_CHAR(paysf_rcdpar) end "parentID",	
	case when paysf_datbeg <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '' else TO_CHAR(paysf_datBeg, 'YYYY-MM-DD') end "dateFrom",	
	case when paysf_datend <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '9999-12-31' else TO_CHAR(paysf_datend, 'YYYY-MM-DD') end "dateTo",
	case when paysf_cd = paysf_nm then paysf_cd else paysf_cd || ' ' || paysf_nm end "description"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.paysf
where paysf_del = 0
