
select 
row_number() over(ORDER BY KPUC1.Kpu_CdNlp) AS "п/н",
KPUC1.Kpu_CdNlp AS "РНОКПП", --taxCode
KPUC1.Kpu_fio  AS "Повний ПІБ", --fullFIO
CONVERT(VARCHAR(10), Kpu_DtRoj , 121) AS "Дата народження", --birthDate
kpu_tn AS "Табельний номер",
KPUC1.Kpu_rcd AS "Зовнішній код",
KdrSREd_SPRcd AS "Ід-тор посади",
'' AS "Ід-тор запису",
CONVERT(VARCHAR(10), KdrSREd_DatN , 121) AS "Дата признач-ня",
'' AS "Наказ про призн.",
'' AS "Дата нак. призн.",
'' AS "Дата ознайом-ня",
'' AS "Дата закінч. дог.",
KdrSRSP_Grf AS "Графік роботи",
'' AS "К-ть годин",
'1' AS "Основне",
'' AS "Коефіцієнт",
'' AS "Є в декреті",
CONVERT(VARCHAR(10), KdrSREd_PrvDatN , 121) AS "Факт прийняття" 
from KdrSREd
 left join KPUC1 ON KPUC1.Kpu_Rcd = KdrSREd.KdrSREd_KpuRcd
 left join kpux on kpux.kpu_rcd = KdrSREd.KdrSREd_KpuRcd
 left join KdrSRSP on KdrSRSP.KdrSRSP_Rcd = KdrSREd.KdrSREd_SPRcd

 

