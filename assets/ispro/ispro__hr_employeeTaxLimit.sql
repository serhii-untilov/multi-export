-- Ï³ëüãè ÏÄÔÎ ïğàö³âíèê³â (hr_employeeTaxLimit)
select 'ID' ID
	,'tabNum' tabNum
	,'employeeNumberID' employeeNumberID
	,'dateFrom' dateFrom, 'dateTo' dateTo, 'taxLimitID' taxLimitID, 'amountChild' amountChild
union all
select 
	cast(l1.bookmark as varchar) ID
	,cast(x1.kpu_tn as varchar) tabNum	 
	,cast( l1.kpu_rcd as varchar) employeeNumberID
	,cast(cast(kpupdxlg_dtn as date) as varchar) dateFrom
	,cast(cast(case when kpupdxlg_dtk = '1876-12-31' then '9999-12-31' else kpupdxlg_dtk end as date) as varchar) dateTo
	,cast(kpupdxlg_cd as varchar) taxLimitID
	,cast(case when kpupdxlg_cd = 2 then 3
		when kpupdxlg_cd = 3 then 4
		when kpupdxlg_cd = 5 then 5 
		when kpupdxlg_cd = 6 then 2
		when kpupdxlg_cd = 30 then 1
		when kpupdxlg_cd = 50 then 1
		when kpupdxlg_cd = 51 then 2
		else 0 end as varchar) amountChild
from KpuPdxOLg01 l1
inner join kpuc1 c1 on c1.kpu_rcd = l1.kpu_rcd
inner join kpux x1 on x1.kpu_rcd = l1.kpu_rcd
where (c1.kpu_flg & 2) = 0