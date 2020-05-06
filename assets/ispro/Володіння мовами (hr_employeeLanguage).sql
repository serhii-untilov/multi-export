-- Володіння мовами (hr_employeeLanguage)
select 
	l1.KpuLng_Rcd ID	
	,c1.kpu_rcd employeeID	
	,c1.kpu_cdnlp taxCode
	,c1.kpu_fio fullFIO
	,cast(cast(c1.kpu_dtroj as date) as varchar) birthDate
	,cast(KpuLng_Cd as varchar) dictLanguageID
	,cast(KpuLng_Cd as varchar) dictLanguageCode
	,cast(s1.spr_nm as varchar) dictLanguageName
	,cast(l1.KpuLng_StV as varchar) dictLanguageLevelID	
	,cast(l1.KpuLng_StV as varchar) dictLanguageLevelCode
	,s2.spr_nm dictLanguageLevelName
	,'' employeeDocID
	,KpuLng_DocNum docNumber
	,'' docSeries	
	,'' docIssuer	
	,case when l1.KpuLng_DocDate <= '1876-12-31' then '' else cast(cast(l1.KpuLng_DocDate as date) as varchar) end dateIssue	
from KpuLng1 l1
inner join kpuc1 c1 on c1.kpu_rcd = l1.kpu_rcd
inner join pspr s1 on s1.sprspr_cd = 680965 and s1.spr_cd = l1.KpuLng_Cd
left join pspr s2 on s2.sprspr_cd = 680966 and s2.spr_cd = l1.KpuLng_StV
