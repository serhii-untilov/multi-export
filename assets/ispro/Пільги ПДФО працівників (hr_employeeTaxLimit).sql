-- ϳ���� ���� ���������� (hr_employeeTaxLimit)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @sprpdr_cd nvarchar(20) = /*SPRPDR_CD*/
/*BEGIN-OF-HEAD*/
select 'ID' ID
	,'tabNum' tabNum
	,'employeeNumberID' employeeNumberID
	,'dateFrom' dateFrom, 'dateTo' dateTo, 'taxLimitID' taxLimitID, 'amountChild' amountChild
union all
/*END-OF-HEAD*/
select 
	cast(l1.bookmark as varchar) ID
	,cast(x1.kpu_tn as varchar) tabNum	 
	,cast( l1.kpu_rcd as varchar) employeeNumberID
	,cast(cast(kpupdxlg_dtn as date) as varchar) dateFrom
	,cast(cast(case when kpupdxlg_dtk <= '1876-12-31' then '9999-12-31' else kpupdxlg_dtk end as date) as varchar) dateTo
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

inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
	select max(pdr2.bookmark)
	from kpuprk1 pdr2 
	where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
		select max(pdr3.kpuprkz_dtv)
		from kpuprk1 pdr3
		where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
	)
) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

where (c1.kpu_flg & 2) = 0
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)