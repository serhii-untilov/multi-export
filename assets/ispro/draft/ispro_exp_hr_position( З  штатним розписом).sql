select 
row_number() over(ORDER BY KdrSRSP_rcd) as "п/н",
KdrSRSP_rcd as "Зовнішній код",
KdrSRSP_PdCd as "Порядковий ном.",  
(
Select cast(sprpdr_rcd as varchar) from sprpdr Where sprpdr.SprPdr_Pd = KdrSRSP_pdcd
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
 SprD_oKlMax as "Максимал. оклад",
KdrSRSP_Okl as "Фактичний оклад",
'' as "Доступ секретн.",
'0' as "Мат. відпов-сть",
'0' as "Номенклат-сть",
'' as "Є розпорядч док.",
'' as "Введ. проект ШР",
SprD_NmIm  as "Назва посади",
SprD_NMR as "Назва (родовий)",
 SprD_NMD as "Назва (дав-ний)",
 SprD_NMT as "Назва (орудний)",
(
Select Spr_Nm from pspr Where pspr.Spr_Cd = KdrSRSP_Kat
and SprSpr_Cd = 549
) as "Тип посади",
 SprD_PrFNmR as "Професія",
(
Select Spr_Nm from pspr Where pspr.Spr_Cd = Sprd_KatCd
and SprSpr_Cd = 580
) as "Тип посади ДС",
(
Select Spr_Nm from pspr Where pspr.Spr_Rcd = Sprd_KatCdK1
)  as "Кат. посади ДС",
(
Select Spr_Nm from pspr Where pspr.Spr_Rcd = Sprd_KatGSCd
) as "Гр. опл. праці ДС",
'' as "Юрисдикція ДО",
'' as "Статус особи"
 FROM KdrSRSP
join KdrSRCt
ON KdrSRCt.KdrSRCt_Rcd = KdrSRSP_CtRcd
left join SPRDOL
ON SPRDOL.SprD_Cd = KdrSRSP_Dol
where KdrSRCt_Stt = 1 
