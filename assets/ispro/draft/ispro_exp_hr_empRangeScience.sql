-- Вивантаження даних щодо наукового ступеню з таблиці KpuNau1 (для подальшого завантаження в таблицю hr_empRangeScience)

select
row_number() over(ORDER BY KPUC1.Kpu_CdNlp) AS "п/н",
KPUC1.Kpu_CdNlp AS "РНОКПП", --taxCode
KPUC1.kpu_rcd  AS "Повний ПІБ", --fullFIO
CONVERT(VARCHAR(10), Kpu_DtRoj , 121) AS "Дата народження", --birthDate
KpuNau_CdNS  AS "Код наук. ст.", -- dictDegreeID
(
Select Spr_Nm from pspr Where pspr.Spr_Cd = KpuNau1.KpuNau_CdNS
and pspr.sprspr_cd = 680964
)  AS "Наук. ступінь", 
KpuNau_CdSp  AS "Код спеціал-ті", --dictspecialtyID
KpuNau_SpNm  AS "Спеціал-ть ВАК",
KpuNau_NmrD  AS "№ д-та про присв.", --docNumber
CONVERT(VARCHAR(10), KpuNau_DtVD , 121)  AS "Дата документа", --docDate
KpuNau_YPr  AS "Рік присвоєння",
KpuNau_Dsr  AS "Тема дисертац.",
KPUC1.kpu_rcd  AS "Зовнішній код"
from KpuNau1
join KPUC1
 ON KPUC1.Kpu_Rcd = KpuNau1.Kpu_Rcd
