-- ���������� �������� ���-����� - ������� ������ (hr_timeSheetChangeDay)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
declare @shiftID bigint = 100000
/*BEGIN-OF-HEAD*/
select 
	'ID' ID
	,'timeSheetChangeID' timeSheetChangeID
	,'numDay' numDay
	,'dictTimeCostID' dictTimeCostID
	,'hoursWork' hoursWork
	,'workShift' workShift
	,'notChangeHoursWork' notChangeHoursWork
	,'payElID' payElID
union all	
/*END-OF-HEAD*/
select 
	cast(p1.bookmark as varchar) ID	
	,cast(p1.PayIgp_Rcd as varchar) timeSheetChangeID	
	,cast(p1.PayIgpPer_Day as varchar) numDay	
	,case when p1.PayIgpPer_Hrs = 0 then '1' else '2' end dictTimeCostID	
	,cast(p1.PayIgpPer_Hrs as varchar) hoursWork
	,cast(p1.PayIgpPer_Smn as varchar) workShift	
	,'' notChangeHoursWork
	,case when p1.PayIgpPer_Hrs = 0 
		then case when PayIgp_VoNWrk = 0 then '' else cast(PayIgp_VoNWrk as varchar) end
		else case when PayIgp_VoWrk = 0 then '' else cast(PayIgp_VoWrk as varchar) end
		end payElID
from PayIgpPB p1
inner join PayIgp i1 on i1.PayIgp_Rcd = p1.PayIgp_Rcd
where i1.PayIgp_DatK <= '1876-12-31' or i1.PayIgp_DatK >= @dateFrom
union all
select 
	cast(p1.bookmark + @shiftID as varchar) ID	
	,cast(i1.bookmark as varchar) timeSheetChangeID	
	,cast(p1.KpuIgrPer_Nmr as varchar) numDay	
	,case when p1.KpuIgrPer_Hrs = 0 then '1' else '2' end dictTimeCostID	
	,cast(p1.KpuIgrPer_Hrs as varchar) hoursWork
	,cast(p1.KpuIgrPer_Smn as varchar) workShift	
	,'' notChangeHoursWork
	,case when p1.KpuIgrPer_Hrs = 0 
		then case when KpuIgr_CdVoV = 0 then '' else cast(KpuIgr_CdVoV as varchar) end
		else case when KpuIgr_CdVo = 0 then '' else cast(KpuIgr_CdVo as varchar) end
		end payElID
from KpuIgrPerB p1
inner join KpuIgrB i1 on i1.kpu_rcd = p1.kpu_rcd and i1.KpuIgr_Nmr = p1.KpuIgr_Nmr
where i1.kpuigr_datEnd <= '1876-12-31' or i1.kpuigr_datEnd >= @dateFrom
