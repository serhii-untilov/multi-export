-- Організації (hr_organization)
select
	SysSte_Rcd "ID",
	SysSte_Cd "code",
	SysSte_Nm "name",
	SysSte_EDR "edrpou"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
order by sysste_cd