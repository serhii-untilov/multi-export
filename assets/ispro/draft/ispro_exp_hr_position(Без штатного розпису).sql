select 
row_number() over(ORDER BY positionID) as "п/н",
cast(positionID as varchar) as "Зовнішній код",
SprD_Cd as "Порядковий ном.",  
(
Select cast(sprpdr_rcd as varchar) from sprpdr Where sprpdr.SprPdr_Rcd = departmentID
)   as "Код підрозділу",
CONVERT(VARCHAR(10), SprD_BegDat , 121)  as "Дата створення",
'' as "№ документа",
'' as "Дата документа",
'' as "Дата ліквідації",
'' as "№ док-та лікв.",
'' as "Дата док-та лікв",
'N' as "Пос. інструкція",
'' as "Дата вступу",
'' as "Дата заверш.",
'' as "Коефіцієнт",
SprD_oKlMin as "Мінімальн. оклад",
SprD_oklmax as "Максимал. оклад",
SprD_OKLdEF as "Фактичний оклад",
'' as "Доступ секретн.",
'0' as "Мат. відпов-сть",
'0' as "Номенклат-сть",
'' as "Є розпорядч док.",
'' as "Введ. проект ШР",
'' as "Назва посади",
SprD_NMR as "Назва (родовий)",
SprD_NMD as "Назва (дав-ний)",
SprD_NMT as "Назва (орудний)",
'' as "Тип посади",
SprD_PrFNmR as "Професія",
(
Select Spr_Nm from pspr Where pspr.Spr_Cd = Sprd_KatCd
and SprSpr_Cd = 580
) as "Тип посади ДС",
(
Select Spr_Nm from pspr Where pspr.Spr_Rcd = Sprd_KatCdK1
)   as "Кат. посади ДС",
(
Select Spr_Nm from pspr Where pspr.Spr_Rcd = Sprd_KatGSCd
) as "Гр. опл. праці ДС",
'' as "Юрисдикція ДО",
'' as "Статус особи"
 FROM SPRDOL
inner join (
	select distinct kpuprk1.kpuprkz_pdrcd * 10000 + kpuprk1.kpuprkz_dol positionID, kpuprk1.kpuprkz_pdrcd departmentID, kpuprk1.kpuprkz_dol dictPositionID
	from kpuprk1
) t1 on t1.dictPositionID = SprD_Cd
where sprd_prz = 0 or exists (
	select null
	from kpuprk1
	where kpuprkz_dol = SprD_Cd
)