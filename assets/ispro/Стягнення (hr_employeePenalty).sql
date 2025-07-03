-- Стягнення (hr_employeePenalty)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
declare @sprpdr_cd nvarchar(20) = /*SPRPDR_CD*/
declare @dateTo date = GETDATE()
declare @employeeDateFrom date = dateadd(month, -3,(select cast(cast((year(getdate()) - 0) * 10000 + 101 as varchar(10)) as date)))
select
	cast(d1.KpuDOt_Rcd as varchar) ID
	,cast(d1.kpu_rcd as varchar) employeeID
	,case when len(c1.kpu_cdnlp) <> 0 then c1.kpu_cdnlp
			when len(c2.kpu_cdnlp) <> 0 then c2.kpu_cdnlp
			when len(psp.KpuPsp_Ser) <> 0 or len(psp.KpuPsp_Nmr) <> 0 then psp.KpuPsp_Ser + ' ' + psp.KpuPsp_Nmr
			when len(psp2.KpuPsp_Ser) <> 0 or len(psp2.KpuPsp_Nmr) <> 0 then psp2.KpuPsp_Ser + ' ' + psp2.KpuPsp_Nmr
			else	'*' +
					left(dbo.fnKdrSegregateFio(c1.kpu_fio, 1), 1) +
					left(dbo.fnKdrSegregateFio(c1.kpu_fio, 2), 1) +
					left(dbo.fnKdrSegregateFio(c1.kpu_fio, 3), 1) +
					cast(day(c1.kpu_dtroj) as varchar) +
					cast(month(c1.kpu_dtroj) as varchar) +
					cast((year(c1.kpu_dtroj) % 100) as varchar)
			 end taxCode
	,cast(d1.kpu_rcd as varchar) employeeNumberID
	,case when c1.kpu_dtroj <= '1876-12-31' then '' else cast(cast(c1.kpu_dtroj as date) as varchar) end bitrhDate
	,case when c1.kpu_dtpst <= '1876-12-31' then '' else cast(cast(c1.kpu_dtpst as date) as varchar) end employeeNumberDateFrom
	,case when c1.kpu_dtuvl <= '1876-12-31' then '' else cast(cast(c1.kpu_dtuvl as date) as varchar) end employeeNumberDateTo
	,case when d1.KpuDOt_CdVid = 0 then '' else cast(d1.KpuDOt_CdVid as varchar) end dictPenaltyID	-- pspr.sprspr_cd = 680972
	,case when d1.KpuDOt_CdPrV = 0 then '' else cast(d1.KpuDOt_CdPrV as varchar) end dictPenaltyReasonID -- pspr.sprspr_cd = 680971
	,'' docIssued
	,case when d1.KpuDOt_DtV <= '1876-12-31' then '' else cast(cast(d1.KpuDOt_DtV as date) as varchar) end docIssuedDate
	,case when d1.KpuDOt_DtPom <= '1876-12-31' then '' else cast(cast(d1.KpuDOt_DtPom as date) as varchar) end dateClosed
	,d1.KpuDOt_NmPr docDescription
	,d1.KpuDOt_Pr comment
	,'' orderID
	,'' orderDetID
	,'' appealDate
from KpuDOt1 d1
inner join KPUC1 c1 ON c1.Kpu_Rcd = d1.Kpu_Rcd
inner join kpux x1 on x1.kpu_rcd = c1.kpu_rcd

inner join kpuprk1 pdr1 on pdr1.kpu_rcd = c1.kpu_rcd and pdr1.bookmark = (
	select max(pdr2.bookmark)
	from kpuprk1 pdr2
	where pdr2.kpu_rcd = c1.kpu_rcd and pdr2.kpuprkz_dtv = (
		select max(pdr3.kpuprkz_dtv)
		from kpuprk1 pdr3
		where pdr3.kpu_rcd = c1.kpu_rcd and pdr3.kpuprkz_dtv <= getdate()
	)
) and (@sprpdr_cd = '' or @sprpdr_cd = left(pdr1.kpuprkz_pd, len(@sprpdr_cd)))

left join kpupsp1 psp on psp.kpu_rcd = x1.kpu_rcd and psp.KpuPsp_Add = 0
left join kpux x2 on x2.kpu_tn = x1.kpu_tnosn
left join KPUC1 c2 ON c2.Kpu_Rcd = x2.Kpu_Rcd
left join kpupsp1 psp2 on psp2.kpu_rcd = x2.kpu_rcd and psp2.KpuPsp_Add = 0
where (@sysste_rcd is null or c1.kpuc_se = @sysste_rcd)
	and (c1.kpu_dtuvl <= '1876-12-31' or c1.kpu_dtuvl >= @employeeDateFrom)