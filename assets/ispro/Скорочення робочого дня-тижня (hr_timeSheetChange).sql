-- ���������� �������� ���-����� (hr_timeSheetChange)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
declare @shiftID bigint = 100000
/*BEGIN-OF-HEAD*/
select
	'ID' ID
	,'orderNumber' orderNumber
	,'orderDate' orderDate
	,'orderState' orderState
	,'empOrderType' empOrderType
	,'typeSheetChange' typeSheetChange
	,'description' description
	,'dateFrom' dateFrom
	,'dateTo' dateTo
	,'comment' comment
	,'orderID' orderID
	,'changeOrderID' changeOrderID
	,'paraID' paraID
	,'reduceHours' reduceHours
	,'scheduleSize' scheduleSize
	,'workPayElID' workPayElID
	,'freePayElID' freePayElID
union all	
/*END-OF-HEAD*/
select
	cast(PayIgp_Rcd as varchar) ID	
	,PayIgp_PrkCd orderNumber	
	,case when PayIgp_PrkDat <= '1876-12-31' then '' else cast(cast(PayIgp_PrkDat as date) as varchar) end orderDate	
	,'POSTED' orderState	
	,'TIMESHEETCHANGE' empOrderType	
	,'1' typeSheetChange	
	,case when PayIgp_prkDat > '1876-12-31' and len(PayIgp_prkCd) > 0 then PayIgp_prkCd + ' �� ' + cast(cast(PayIgp_prkDat as date) as varchar) else '' end description	
	,cast(cast(PayIgp_datN as date) as varchar) dateFrom	
	,case when PayIgp_datK <= '1876-12-31' then '9999-12-31' else cast(cast(PayIgp_datK as date) as varchar) end dateTo	
	,'' comment	
	,'' orderID	
	,'' changeOrderID	
	,'' paraID
	,case when PayIgp_CutHrs = 0 then '' else cast(PayIgp_CutHrs as varchar) end reduceHours
	,cast(PayIgp_PerSize as varchar) scheduleSize
	,case when PayIgp_VoWrk = 0 then '' else cast(PayIgp_VoWrk as varchar) end workPayElID
	,case when PayIgp_VoNWrk = 0 then '' else cast(PayIgp_VoNWrk as varchar) end freePayElID
from PayIgp
where PayIgp_DatK <= '1876-12-31' or PayIgp_DatK >= @dateFrom
union all
select
	cast(i1.bookmark + @shiftID as varchar) ID	
	,kpuigr_prkCd orderNumber	
	,case when kpuigr_prkDat <= '1876-12-31' then '' else cast(cast(kpuigr_prkDat as date) as varchar) end orderDate	
	,'POSTED' orderState	
	,'TIMESHEETCHANGE' empOrderType	
	,'1' typeSheetChange	
	,case when kpuigr_prkDat > '1876-12-31' and len(kpuigr_prkCd) > 0 then kpuigr_prkCd + ' �� ' + cast(cast(kpuigr_prkDat as date) as varchar) else '' end description	
	,cast(cast(kpuigr_datBeg as date) as varchar) dateFrom	
	,case when kpuigr_datEnd <= '1876-12-31' then '9999-12-31' else cast(cast(kpuigr_datEnd as date) as varchar) end dateTo	
	,'' comment	
	,'' orderID	
	,'' changeOrderID	
	,'' paraID
	,case when KpuIgrCut_Hrs = 0 then '' else cast(KpuIgrCut_Hrs as varchar) end reduceHours
	,cast((select count(*) from KpuIgrPerB p1 where p1.kpu_rcd = i1.kpu_rcd and p1.KpuIgr_Nmr = i1.KpuIgr_Nmr) as varchar) scheduleSize
	,case when KpuIgr_CdVo = 0 then '' else cast(KpuIgr_CdVo as varchar) end workPayElID
	,case when KpuIgr_CdVoV = 0 then '' else cast(KpuIgr_CdVoV as varchar) end freePayElID
from KpuIgrB i1
inner join kpuc1 c1 on c1.kpu_rcd = i1.kpu_rcd
where kpuigr_datEnd <= '1876-12-31' or kpuigr_datEnd >= @dateFrom
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)