-- ����������� ����� ���������� (hr_accrual)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @dateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 1) * 10000 + 101 as varchar(10)) as date)))
declare @currentPeriod date = (
	select CASE WHEN LEN (RTRIM(CrtParm_Val)) = 8 THEN CONVERT(DATE, CrtParm_Val, 3) ELSE	CONVERT(DATE, CrtParm_Val, 103) END
	from vwCrtParm 
	where crtParm_cdBpr = 2
	and crtParm_id = 'Period_DatOpen'
	and (@sysste_rcd is null or CrtFrm_Rcd = @sysste_rcd)
)
/*BEGIN-OF-HEAD*/
select 
	'ID' ID	
	,'periodCalc' periodCalc	
	,'periodSalary' periodSalary	
	,'tabNum' tabNum
	,'employeeNumberID'	employeeNumberID
	,'payElID' payElID	
	,'baseSum' baseSum
	,'rate' rate
	,'paySum' paySum	
	,'days' days	
	,'hours' hours	
	,'calculateDate' calculateDate	
	,'mask' mask	
	,'flagsRec' flagsRec
	,'flagsFix' flagsFix	
	,'planHours' planHours	
	,'planDays' planDays	
	,'maskAdd' maskAdd	
	,'dateFrom' dateFrom	
	,'dateTo' dateTo	
	,'source' source	
	,'sourceID' sourceID
	,'dateFromAvg' dateFromAvg	
	,'dateToAvg' dateToAvg	
	,'sumAvg' sumAvg
	,'employeeNumberPartID' employeeNumberPartID
union all
/*END-OF-HEAD*/
select 
	cast(r1.bookmark as varchar) ID	
	,cast(cast(r1.kpurl_datUp as DATE) as varchar) periodCalc	
	,cast(cast(r1.kpurl_datRp as DATE) as varchar) periodSalary	
	,cast(x1.kpu_tn as varchar) tabNum
	,cast(x1.kpu_rcd as varchar) employeeNumberID	
	,cast(r1.kpurl_cdvo as varchar) payElID	
	,cast(cast(( { fn CONVERT( case when (r1.kpurl_prz & 8) = 0 then r1.kpurlPl_Sm else -r1.kpurlPl_Sm end, SQL_DOUBLE ) } / { fn POWER( 10, KpuRlPl_SmMT ) } ) as numeric(19,2)) as varchar) baseSum
	,cast(cast(( { fn CONVERT( r1.kpurlPl_Prc, SQL_DOUBLE ) } / { fn POWER( 10, KpuRlPl_PrcMT ) } ) as numeric(19,2)) as varchar) rate
	,cast(CONVERT(DECIMAL(19, 0), r1.kpurl_Sm) / 100 as varchar) paySum	
	,cast(case when (r1.kpurl_prz & 8) = 0 then r1.kpurl_days else -r1.kpurl_days end as varchar) days	
	,cast(case when (r1.kpurl_prz & 8) = 0 then r1.kpurl_hrs else -r1.kpurl_hrs end as varchar) hours	
	,cast(case when r1.KpuRlTS_Dat <= '1876-12-31' then null else cast(r1.KpuRlTS_Dat as date) end as varchar) calculateDate	
	,cast(r1.KpuRl_Msk as varchar) mask	
	,cast(8 -- ������
		| (case when (KpuRl_Prz & 8) <> 0 then 512 else 0 end)	-- ������
		| (case when (KpuRl_Prz & 16) <> 0 then 1024 else 0 end)	-- ������������
		| (case when r1.KpuRlSvm_Tn <> 0 then 4096 else 0 end)  -- ������ ����������� ������������
		| (case when r1.KpuRlSvm_Tn <> 0 then 8192 else 0 end)  -- �� ������ � ����� ��������� � ��������
		| (case when (r1.KpuRl_Prz & 65536) <> 0 then 4096 else 0 end)  -- ������ ����������� ������������
		| (case when (r1.KpuRl_Prz & 65536) <> 0 then 8192 else 0 end)  -- �� ������ � ����� ��������� � ��������
		| (case when v1.Vo_NUR <> 0 then 8192 else 0 end)  -- �� ������ � ����� ��������� � ��������
		| (case when (KpuRl_Prz & 2) <> 0 then 4 else 0 end)	-- ������� �������
		| (case when (KpuRl_Prz & 1) <> 0 then 1 else 0 end)	-- ���������� �������������
		| (case when (KpuRl_Prz & 4) <> 0 then 2 else 0 end)	-- ��������� �� ����������
		| (case when (KpuRl_Prz & 262144) <> 0 then 32 else 0 end)	-- �� ���������� �� �����
		| (case when (KpuRl_Prz & 16) <> 0 then 1024 else 0 end)	-- ������������/������
		| (case when v1.vo_met = 117 and kmPl.kpurlclc_sm is not null and (kmPl.kpurlclc_sm & 0x40) <> 0 then 256 else 0 end) -- ������������ ���������� �� ��������� ���������
		as varchar) flagsRec
	,cast(case when v1.Vo_Grp < 128 and (r1.KpuRl_Msk | r1.kpurl_addmsk) = 0 then 2147483647 else 0 end as varchar) flagsFix	
	,cast(r1.kpurlPl_hrs as varchar) planHours	
	,cast(r1.kpurlPl_days as varchar) planDays	
	,cast(r1.kpurl_addmsk as varchar) maskAdd	
	,cast(cast(case when r1.KpuRlPr_Dn <= '1876-12-31' then null else r1.KpuRlPr_Dn end as date) as varchar) dateFrom	
	,cast(cast(case when r1.KpuRlPr_Dk <= '1876-12-31' then null else r1.KpuRlPr_Dk end as date) as varchar) dateTo	
	,cast(case 
			when r1.KpuRlSvm_Tn <> 0 then null
			when n2.pdnch_rcd is not null then 'hr_payPerm'	-- ������� �����������/��������� �����������
			when n1.kpunch_id is not null then 'hr_employeeAccrual'	-- ������� ����������� �� ���.�������
			when u2.pdudr_rcd is not null then 'hr_payPerm'	-- ������� �����������/��������� �����������
			when u1.kpuudr_id is not null then 'hr_payRetention'	-- ������� ��������� �� ���.�������
			when p1.bookmark is not null then 'hr_employeePosition' -- ����������� ����������
			else null end as varchar) source
	,cast(case 
			when r1.KpuRlSvm_Tn <> 0 then null
			when n2.pdnch_rcd is not null then n2.pdnch_rcd	-- ������� �����������/��������� �����������
			when n1.kpunch_id is not null then n1.kpunch_id	-- ������� ����������� �� ���.�������
			when u2.pdudr_rcd is not null then 65535 + u2.pdudr_rcd	-- ������� �����������/��������� �����������
			when u1.kpuudr_id is not null then u1.kpuudr_id	-- ������� ��������� �� ���.�������
			when p1.bookmark is not null then p1.bookmark -- ����������� ����������
			else null end as varchar) sourceID
	,cast(case when r1.KpuRlPrZr_Dn <= '1876-12-31' then null else cast(r1.KpuRlPrZr_Dn as date) end as varchar) dateFromAvg	
	,cast(case when r1.KpuRlPrZr_Dk <= '1876-12-31' then null else cast(r1.KpuRlPrZr_Dk as date) end as varchar) dateToAvg	
	,cast(cast(KpuRlPl_SrZ as numeric(19, 2)) as varchar) sumAvg
	,case when r1.KpuRlSvm_Tn = 0 then '' else cast (svm.Kpu_Rcd as varchar) end employeeNumberPartID
from kpurlo1 r1
inner join KPUX x1 on x1.Kpu_Tn = r1.Kpu_Tn
inner join KPUC1 c1 on c1.Kpu_Rcd = x1.kpu_rcd
inner join PAYVO1 v1 on v1.Vo_Cd = r1.kpurl_cdvo
left join kpunch1 n1 on v1.vo_grp < 128 and n1.kpu_rcd = x1.kpu_rcd and n1.kpunch_cd = r1.kpurl_cdvo and r1.kpurllnk_ls = n1.kpunch_rcd and (kpurl_prz & 16384) = 0 
left join pdnch n2 on v1.vo_grp < 128 and n2.pdnch_cd = r1.kpurl_cdvo and r1.kpurllnk_ls = n2.pdnch_rcd and (kpurl_prz & 16384) <> 0
left join kpuudr1 u1 on v1.vo_grp > 127 and u1.kpu_rcd = x1.kpu_rcd and u1.kpuudr_cd = r1.kpurl_cdvo and r1.kpurllnk_ls = u1.kpuudr_rcd and (kpurl_prz & 16384) = 0 
left join pdudr u2 on v1.vo_grp > 127 and u2.pdudr_cd = r1.kpurl_cdvo and r1.kpurllnk_ls = u2.pdudr_rcd and (kpurl_prz & 16384) <> 0
left join kpuprk1 p1 on v1.vo_grp = 1 and r1.KpuRlPr_Dn >= r1.kpurl_datrp 
	and p1.kpu_rcd = x1.kpu_rcd and p1.bookmark =
	(	select min(p2.bookmark)
		from kpuprk1 p2
		where p2.kpu_rcd = x1.kpu_rcd
			and p2.kpuprkz_dtv =
			(	select max(p3.kpuprkz_dtv)
				from kpuprk1 p3
				where p3.kpu_rcd = x1.kpu_rcd
				and p3.kpuprkz_dtv <= r1.KpuRlPr_Dn
			)
	)
	and r1.kpurl_cdvo = p1.kpuprkz_sysop
left join kpux svm on svm.kpu_tn = r1.KpuRlSvm_Tn
left join kpurloclc kmPl -- ������� "������������ �� ��������� ���������
	on kmPl.kpu_tn = r1.kpu_tn and kmPl.KpuRl_DatRp = r1.KpuRl_DatRp and kmPl.KpuRl_Rcd = r1.KpuRl_Rcd
	and v1.vo_met = 117
	and kmPl.kpurlclc_pk = 14 -- and (kmPl.kpurlclc_sm & 0x40) <> 0
where r1.KpuRl_CdVo <> 0
	and r1.KpuRl_DatUp >= @dateFrom
	--and (KpuRl_Prz & 65536) = 0 -- ������ ����������� ������������ - ����������
	--and (r1.KpuRl_DatUp < @currentPeriod or {fn MOD({fn TRUNCATE(KpuRl_Prz / 1, 0)}, 2)} = 0) 
	--and (r1.KpuRl_DatUp < @currentPeriod or {fn MOD({fn TRUNCATE(KpuRl_Prz / 2048, 0)}, 2)} = 0)
	--and (r1.KpuRl_DatUp < @currentPeriod or (KpuRl_Prz & 65536) = 0)
	and r1.KpuRl_DatUp < @currentPeriod
	and (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
