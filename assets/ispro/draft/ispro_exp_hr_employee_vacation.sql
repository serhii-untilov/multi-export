select
row_number() over(ORDER BY KPUC1.Kpu_CdNlp) AS "п/н",
KPUC1.Kpu_CdNlp AS "РНОКПП", --taxCode
KPUC1.kpu_rcd  AS "Повний ПІБ", --fullFIO
CONVERT(VARCHAR(10), Kpu_DtRoj , 121) AS "Дата народження", --birthDate
(
Select Spr_Nm from pspr Where pspr.Spr_Cd = KpuOtpf1.KpuOtpF_Cd
and pspr.sprspr_cd = 787202
)  AS "Вид відпустки", --
CONVERT(VARCHAR(10), KpuOtpF_PDn , 121)  AS "Початок періоду", --
CONVERT(VARCHAR(10), KpuOtpF_PDk , 121)  AS "Кінець періоду", --
KpuOtpF_Len  AS "Дні відпустки", --
SUM(KpuOtpF_Use)  AS "Використані дні", --
CONVERT(VARCHAR(10), KPUC1.kpu_DtPst , 121)  AS "Факт прийняття", --
KPUC1.kpu_rcd  AS "Зовнішній код" --
from KpuOtpf1
join KPUC1
 ON KPUC1.Kpu_Rcd = KpuOtpf1.Kpu_Rcd
 where KpuOtpf1.KpuOtpF_Len >0
Group by KPUC1.Kpu_CdNlp, KPUC1.kpu_rcd, Kpu_DtRoj, KpuOtpf1.KpuOtpF_Cd, KpuOtpf1.KpuOtpF_PDn,KpuOtpF_PDk, KPUC1.kpu_DtPst, KpuOtpf1.KpuOtpF_Len