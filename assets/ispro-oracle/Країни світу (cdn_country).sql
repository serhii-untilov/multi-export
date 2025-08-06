-- Країни світу (cdn_country)
select
    SAdrCnt_Rcd "ID",
    SAdrCnt_Cd "code",
    SAdrCnt_Nm "name"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.vwSAdrCnt
