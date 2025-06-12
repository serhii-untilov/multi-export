-- Постійні нарахуванна та утримання по організіції (hr_payPerm)
select 
	pdnch_rcd "ID"
	,'PAYMENT' "payType"
	,pdnch_cd "payElID"
	,case 
		when pdnch_datn <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '' 
		else TO_CHAR(pdnch_datn, 'YYYY-MM-DD') 
		end "dateFrom"
	,case 
		when pdnch_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '9999-12-31' 
		else TO_CHAR(pdnch_datk, 'YYYY-MM-DD') 
		end "dateTo"
	,case 
		when BITAND(pdnch_prz, 2) = 0 then pdnch_sm / power(10, pdnch_mt) 
		else 0 
		end "paySum"
	,case 
		when BITAND(pdnch_prz, 2) <> 0 then pdnch_sm / power(10, pdnch_mt) 
		else 0 
		end "rate"
	,case 
		when pdnch_sf = 0 then '' 
		else TO_CHAR(pdnch_sf) 
		end "dictFundSourceID"
	,case 
		when pdnch_sch = 0 then '' 
		else TO_CHAR(pdnch_sch) 
		end "accountID"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.PdNch
where PdNch_Del = 0 and 
	(pdnch_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		or pdnch_datk >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
	)
union all
select 
	65535 + pdudr_rcd "ID"
	,'OFFTAKE' "payType"
	,pdudr_cd "payElID"
	,TO_CHAR(pdudr_datn, 'YYYY-MM-DD') "dateFrom"
	,case 
		when pdudr_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '9999-12-31' 
		else TO_CHAR(pdudr_datk, 'YYYY-MM-DD') 
		end "dateTo"
	,case 
		when BITAND(pdudr_prz, 2) = 0 then pdudr_sm / power(10, pdudr_mt) 
		else 0 
		end "paySum"
	,case 
		when BITAND(pdudr_prz, 2) <> 0 then pdudr_sm / power(10, pdudr_mt) 
		else 0 
		end "rate"
	,case 
		when pdudr_sf = 0 then '' 
		else TO_CHAR(pdudr_sf) 
		end "dictFundSourceID"
	,'' "accountID"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.pdudr
where PdUdr_Del = 0 and 
	(pdudr_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		or pdudr_datk >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3)
	)
