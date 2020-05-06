-- Члени сімї (hr_employeeFamily)
select 
	KpuSem_Rcd ID
	,s1.kpu_rcd employeeID	
	,c1.kpu_cdnlp taxCode
	,c1.kpu_fio fullFIO
	,cast(cast(c1.kpu_dtroj as date) as varchar) birthDate
	,cast(cast(s1.KpuSem_Dt as date) as varchar) relativeBirthDate
	,'' dateTo	
	,case when s1.KpuSem_Cd is null then '' else cast(s1.KpuSem_Cd as varchar) end dictKinshipKindID
	,'' peopleID
	,case 
		when p1.spr_nm like '%доч%' then '1' 
		when p1.spr_nm like '%син%' then '1'
		when p1.spr_nm like '%сын%' then '1'
		else '0' end isDependent	
	,case when s1.KpuSem_Dt <= '1876-12-31' then '' else cast(cast(s1.KpuSem_Dt as date) as varchar) end + ' ' + coalesce(p1.spr_nm, ' ') + ' ' + s1.kpusem_fio description	
	,case 
		when len(s1.KpuSem_TelMob) > 0 then 'тел. ' + s1.KpuSem_TelMob 
		when len(s1.KpuSem_TelDom) > 0 then 'тел. ' + s1.KpuSem_TelDom
		when len(s1.KpuSem_TelSlg) > 0 then 'тел. ' + s1.KpuSem_TelSlg
		end coment
from KpuSem1 s1
join KPUC1 c1 ON c1.Kpu_Rcd = s1.Kpu_Rcd
left join pspr p1 on p1.sprspr_cd = 680980 and p1.spr_cd = s1.kpusem_cd