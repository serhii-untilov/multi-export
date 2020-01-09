-- Інвалідність (hr_employeeDisability)
/*BEGIN-OF-HEAD*/
select
	'ID' ID
	,'employeeID' employeeID
	,'disabilityID' disabilityID
	,'disabilityGroup' disabilityGroup
	,'dateFrom' dateFrom
	,'dateTo' dateTo
	,'docNumber' docNumber
	,'docSeries' docSeries
	,'docIssuer' docIssuer
	,'dateIssue' dateIssue
	,'workReference' workReference
	,'programDescription' programDescription
	,'programNumber' programNumber
	,'programDate' programDate
	,'programIssuer' programIssuer
	,'employeeDocID' employeeDocID
	,'description' description
union all
/*END-OF-HEAD*/
select 
	cast(i1.bookmark as varchar) ID
	,cast(c1.kpu_rcd as varchar) employeeID --cast(i1.kpu_rcd as varchar) employeeID
	,cast(KpuInv_VIn as varchar) disabilityID
	,left(cast(KpuInv_Grp as varchar), 5) disabilityGroup
	,cast(cast(case when KpuInv_DtN = '1876-12-31' then null else KpuInv_DtN end as date) as varchar) dateFrom
	,cast(cast(case when KpuInv_DtK = '1876-12-31' then '9999-12-31' else KpuInv_DtK end as date) as varchar) dateTo
	,left(REPLACE(REPLACE(KpuInv_Nmr, CHAR(13), ''), CHAR(10), ''), 20) docNumber
	,left(REPLACE(REPLACE(KpuInv_Sn, CHAR(13), ''), CHAR(10), ''), 10) docSeries
	,REPLACE(REPLACE(KpuInv_Who, CHAR(13), ''), CHAR(10), '') docIssuer
	,cast(cast(case when KpuInv_DtS = '1876-12-31' then null else KpuInv_DtS end as date) as varchar) dateIssue
	,REPLACE(REPLACE(KpuInv_TR, CHAR(13), ''), CHAR(10), '') workReference
	,REPLACE(REPLACE(KpuInv_IPR, CHAR(13), ''), CHAR(10), '') programDescription
	,left(REPLACE(REPLACE(KpuInv_NmrIPR, CHAR(13), ''), CHAR(10), ''), 10) programNumber
	,cast(cast(case when KpuInv_DtIPR = '1876-12-31' then null else KpuInv_DtIPR end as date) as varchar) programDate
	,REPLACE(REPLACE(KpuInv_WhoIPR, CHAR(13), ''), CHAR(10), '') programIssuer
	,null employeeDocID	
	,coalesce(spr_nm, '')
		+ case when spr_nm is not null and len(spr_nm) > 0 then ', ' else '' end + case when KpuInv_Grp > 0 then cast(KpuInv_Grp as varchar) else '' end + case when KpuInv_Grp > 0 then ' група' else '' end
		+ case when KpuInv_DtN > '1876-12-31' and ((spr_nm is not null and len(spr_nm) > 0) or KpuInv_Grp > 0) then ', ' else '' end 
			+ case when (spr_nm is not null and len(spr_nm) > 0) or KpuInv_Grp > 0 then ' з ' else '' end 
				+ case when KpuInv_DtN > '1876-12-31' then convert(varchar, KpuInv_DtN, 104) else '' end
		--+ case when KpuInv_DtK > '1876-12-31' and ((spr_nm is not null and len(spr_nm) > 0) or KpuInv_Grp > 0 or KpuInv_DtN > '1876-12-31') then ', ' else '' end 
			+ case when KpuInv_DtK > '1876-12-31' and ((spr_nm is not null and len(spr_nm) > 0) or KpuInv_Grp > 0 or KpuInv_DtN > '1876-12-31') then ' по ' else '' end 
				+ case when KpuInv_DtK > '1876-12-31' then convert(varchar, KpuInv_DtK, 104) else '' end
		description
from kpuinv i1
inner join kpuc1 c1 on c1.kpu_rcd = i1.kpu_rcd
inner join (
	-- Обеспечение уникальности по ИНН
	select max(kpu_rcd) kpu_rcd, kpu_cdnlp
	from (
		select 
			x1.kpu_rcd
			,case when len(c1.kpu_cdnlp) <> 0 then c1.kpu_cdnlp
				when len(p1.KpuPsp_Ser) <> 0 or len(p1.KpuPsp_Nmr) <> 0 then p1.KpuPsp_Ser + ' ' + p1.KpuPsp_Nmr
				else	'*' +
						left(dbo.fnKdrSegregateFio(c1.kpu_fio, 1), 1) +
						left(dbo.fnKdrSegregateFio(c1.kpu_fio, 2), 1) +
						left(dbo.fnKdrSegregateFio(c1.kpu_fio, 3), 1) +
						cast(day(c1.kpu_dtroj) as varchar) +
						cast(month(c1.kpu_dtroj) as varchar) +
						cast((year(c1.kpu_dtroj) % 100) as varchar)
				 end kpu_cdnlp
		from kpux x1
		inner join KPUC1 c1 on c1.Kpu_Rcd = x1.kpu_rcd
		inner join KPUK1 k1 on k1.Kpu_Rcd = x1.kpu_rcd
		left join kpupsp1 p1 on p1.kpu_rcd = x1.kpu_rcd and KpuPsp_Add = 0
		where x1.kpu_tn < 4000000000
			and { fn MOD( { fn TRUNCATE( Kpu_Flg / 64, 0 ) }, 2 ) } = 0
			and (Kpu_Flg & 2) = 0	-- Удалён в зарплате
			and x1.kpu_tnosn = 0
	) t1
	group by kpu_cdnlp
) t1 on t1.kpu_rcd = c1.kpu_rcd
left join /*SYS_SCHEMA*/i711_sys.dbo.sspr on sprspr_cd = 681037 and spr_cdlng = 2 and spr_cd = KpuInv_VIn
where (c1.Kpu_Flg & 2) = 0	-- Удалён в зарплате
