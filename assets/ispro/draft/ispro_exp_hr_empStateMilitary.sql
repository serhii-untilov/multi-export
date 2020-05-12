-- Вивантаження даних щодо військової служби з таблиці  (для подальшого завантаження в таблицю hr_empStateMilitary)
--KpuWar1 - Воинский учет
--KpuNVP1 - Начальная военная подготовка
--KpuVZBP1 - Присвоение воинских званий до поступления
--KpuBtl1 - Участие в боевых действиях


select
row_number() over(ORDER BY KPUC1.Kpu_CdNlp) AS "п/н",
KPUC1.Kpu_CdNlp AS "РНОКПП", --taxCode
KPUC1.Kpu_rcd  AS "Повний ПІБ", --fullFIO
CONVERT(VARCHAR(10), Kpu_DtRoj , 121) AS "Дата народження", --birthDate
case  
when KpuWar_VobCd = 2 then '03'
when KpuWar_VobCd = 1 then '02'
when KpuWar_VobCd = 3 then '01'
when KpuWar_VobCd = 4 then '04'
else '' 
 end AS "Стан обліку", --dictStateMilitaryID
(
Select Spr_NmLong from pspr Where pspr.Spr_Cd = KpuWar1.KpuWar_CdGr
and pspr.sprspr_cd = 680973
) AS "Група обліку", --groupAccounting
case  
when KpuWar_CdKat = 1 then '01'
when KpuWar_CdKat = 2 then '02'
else '' 
 end  AS "Категор. обліку",  -- dictCategMilitaryID
(
Select Spr_Nm from pspr Where pspr.Spr_Cd = KpuWar1.KpuWar_CdSos
and pspr.sprspr_cd = 680975
) AS "Склад",	--composition
KpuWar_CdZvn AS "Код військ. зв.",
(
Select Spr_Nm from pspr Where pspr.Spr_Cd = KpuWar1.KpuWar_CdZvn
and pspr.sprspr_cd = 531
) AS "Військ. звання" , --dictMilitaryRankID
KpuWar_CdSos AS "Код пр оф зап.",  --
(
Select Spr_Nm from pspr Where pspr.Spr_Cd = KpuWar1.KpuWar_CdSos
and pspr.sprspr_cd = 680975
) AS "Профіль оф зап", --
KpuWar_nMRsP AS "ВОС",  --dictMilitarySpecialtyID
(
Select Spr_Nm from pspr Where pspr.Spr_Cd = KpuWar1.KpuWar_doc
and pspr.sprspr_cd = 681071
) AS "Назва РВК", --
(
Select Spr_Nm from pspr Where pspr.Spr_Cd = KpuWar1.KpuWar_Godn
and pspr.sprspr_cd = 680977
) AS "Придатн. до ВС", --
(
Select Spr_Nm from pspr Where pspr.Spr_Cd = KpuWar1.KpuWar_Godn
and pspr.sprspr_cd = 680977
) AS "Придатність",  --dictMilitarySuitableID
'' AS "Примітки", 
'' AS "Дата зв. запас",
'' AS "Був офіц. 2-3 р.",
CONVERT(VARCHAR(10), KpuWar_DtDoc , 121) AS "Дата видачі ВК",
KpuWar_DocN AS "Номер квитка",
'' AS "Бронювання",
'' AS "Бронь строком на",
KpuWar_Spu AS "№ постанови",
KpuWar_Beg AS "Дата постанови",
KpuWar_Spu AS "Спецоблік",
''  AS "Дата відстрочки",
''  AS "Відстрочка до",
(
Select Spr_Nm from pspr Where pspr.Spr_Cd = KpuWar1.KpuWar_RVR
and pspr.sprspr_cd = 680978
) AS "РВК реєстрац.",	 --office
''  AS "Розписка, дата",
''  AS "Розписка, №",
(
Select Spr_Nm from pspr Where pspr.Spr_Cd = KpuWar1.KpuWar_CdMP
and pspr.sprspr_cd = 681018
)  AS "Моб. розпорядж.",
case  
when KpuWar_EndCd = 1 then 'За віком'
when KpuWar_EndCd = 2 then 'За станом здоров"я'
when KpuWar_EndCd = 3 then 'Був засуджений'
when KpuWar_EndCd = 4 then 'Вибуття за межі України на ПМЖ'
else '' 
 end AS "Причина зняття",
KPUC1.Kpu_rcd  AS "Зовнішній код"
 from KpuWar1
 join KPUC1
 ON KPUC1.Kpu_Rcd = KpuWar1.Kpu_Rcd