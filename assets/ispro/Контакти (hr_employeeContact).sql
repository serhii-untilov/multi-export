--  онтакти (hr_employeeContact)
/*BEGIN-OF-HEAD*/
select 'ID' ID
	,'employeeID' employeeID
	,'taxCode' taxCode
	,'fullFIO' fullFIO
	,'birthDate' birthDate
	,'contactTypeID' contactTypeID
	,'contactTypeCode' contactTypeCode
	,'value' value
union all	
/*END-OF-HEAD*/
select 
	cast(row_number() over(partition BY employeeID,birthDate,contactTypeID ORDER BY employeeID,birthDate,contactTypeID) as varchar) ID
	,employeeID
	,taxCode
	,fullFIO
	,birthDate
	,contactTypeID
	,contactTypeCode
	,value
from (
	select -- email
		cast(c1.kpu_rcd	as varchar) employeeID
		,c1.kpu_cdnlp taxCode
		,c1.kpu_fio fullFIO
		,case when c1.kpu_dtroj <= '1876-12-31' then '' else cast(cast(c1.kpu_dtroj as date) as varchar) end birthDate 
		,'1' contactTypeID	
		,'email' contactTypeCode
		,c1.kpu_email value	
	from kpuc1 c1
	inner join kpux x1 on x1.kpu_rcd = c1.kpu_rcd and x1.kpu_tnosn = 0
	where len(c1.kpu_email) > 0
	union
	-- адрес
	select -- kpuadr_cd: 1 - прописка, 2 - проживание, 3 - рождение
		cast(c1.kpu_rcd	as varchar) employeeID
		,c1.kpu_cdnlp taxCode
		,c1.kpu_fio fullFIO
		,case when c1.kpu_dtroj <= '1876-12-31' then '' else cast(cast(c1.kpu_dtroj as date) as varchar) end birthDate 
		,case when kpuadr_cd = 1 then '2' else '3' end contactTypeID	
		,case when kpuadr_cd = 1 then 'legalAddr' else 'actualAddr' end contactTypeCode
		,case when len(KpuAdr_S) > 0 then KpuAdr_S else (
			case when KpuAdr_Index is not null then KpuAdr_Index + ',' else '' end +
			case when KpuAdr_CntNm is not null then KpuAdr_CntNm + ',' else '' end +
			case when KpuAdr_RegNm is not null then KpuAdr_RegNm + ',' else '' end +
			case when KpuAdr_ZoneN is not null then KpuAdr_ZoneN + ' р-н,' else '' end +
			case when KpuAdr_TownN is not null then 'м.' + KpuAdr_TownN + ',' else '' end +
			case when KpuAdr_PlacN is not null then KpuAdr_PlacN + ',' else '' end +
			case when KpuAdr_StrN is not null then KpuAdr_StrN + ',' else '' end +
			case when KpuAdr_House is not null then KpuAdr_House + ',' else '' end +
			case when KpuAdr_Korp is not null then KpuAdr_Korp + ',' else '' end +
			case when KpuAdr_Flat is not null then  KpuAdr_Flat end
		) end value
	from KpuAdr1 a1
	inner join kpuc1 c1 on c1.kpu_rcd = a1.kpu_rcd
	inner join kpux x1 on x1.kpu_rcd = c1.kpu_rcd and x1.kpu_tnosn = 0
	where kpuadr_cd in (1,2)
	union
	select -- phone
		cast(c1.kpu_rcd	as varchar) employeeID
		,c1.kpu_cdnlp taxCode
		,c1.kpu_fio fullFIO
		,case when c1.kpu_dtroj <= '1876-12-31' then '' else cast(cast(c1.kpu_dtroj as date) as varchar) end birthDate 
		,'4' contactTypeID	
		,'phone' contactTypeCode
		,c1.Kpu_Tel value	
	from kpuc1 c1
	inner join kpux x1 on x1.kpu_rcd = c1.kpu_rcd and x1.kpu_tnosn = 0
	where len(c1.kpu_email) > 0
	union
	select -- mobPhone
		cast(c1.kpu_rcd	as varchar) employeeID
		,c1.kpu_cdnlp taxCode
		,c1.kpu_fio fullFIO
		,case when c1.kpu_dtroj <= '1876-12-31' then '' else cast(cast(c1.kpu_dtroj as date) as varchar) end birthDate 
		,'4' contactTypeID	
		,'phone' contactTypeCode
		,c1.Kpu_TelM value	
	from kpuc1 c1
	inner join kpux x1 on x1.kpu_rcd = c1.kpu_rcd and x1.kpu_tnosn = 0
	where len(c1.kpu_email) > 0
) t1
