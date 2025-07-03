-- Довідник джерел фінансування (sia_dictFundSource)
select
	cast(paysf_rcd as varchar) ID,
	paysf_cd code,
	paysf_nm name,
	case when paysf_rcdpar = 0 then '' else cast(paysf_rcdpar as varchar) end parentID,
	case when paysf_datbeg = '1876-12-31' then '' else cast(cast(paysf_datBeg as date) as varchar) end dateFrom,
	case when paysf_datend = '1876-12-31' then '9999-12-31' else cast(cast(paysf_datend as date) as varchar) end dateTo,
	case when paysf_cd = paysf_nm then paysf_cd else paysf_cd + ' ' + paysf_nm end description
from paysf
where paysf_del = 0
