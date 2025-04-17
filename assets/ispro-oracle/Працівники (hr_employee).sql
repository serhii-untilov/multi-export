-- (hr_employee)
/*SYSSTE_BEGIN*/
with ste1 as (select max(sysste_rcd) sysste_rcd from /*FIRM_SCHEMA*/dfirm001.sysste where sysste_cd = /*SYSSTE_CD*/)
/*SYSSTE_END*/
select
	cast(x1.kpu_rcd as varchar(11)) ID
/*
	,fnKdrSegregateFio(c1.kpu_fio, 1) lastName
	,fnKdrSegregateFio(c1.kpu_fio, 2) firstName
	,fnKdrSegregateFio(c1.kpu_fio, 3) middleName
	,fnKdrSegregateFio(c1.kpu_fio, 1) + ' ' + SUBSTR(fnKdrSegregateFio(c1.kpu_fio, 2), 0, 1) + '. ' + SUBSTR(fnKdrSegregateFio(c1.kpu_fio, 3), 0, 1) + '. ' shortFIO
*/
	,REPLACE(REPLACE(c1.kpu_fio, CHR(13), ''), CHR(10), '') fullFIO
	,REPLACE(REPLACE(c1.kpu_fioR, CHR(13), ''), CHR(10), '') genName
	,REPLACE(REPLACE(c1.kpu_fioD, CHR(13), ''), CHR(10), '') datName
	,REPLACE(REPLACE(c1.kpu_fioV, CHR(13), ''), CHR(10), '') accusativeName
	,REPLACE(REPLACE(c1.kpu_fio, CHR(13), ''), CHR(10), '') insName
	,cast(x1.kpu_tn as varCHaR(10)) tabNum
	,'NEW' state
	,case when c1.kpu_cdpol = 1 then 'W' when c1.kpu_cdpol = 2 then 'M' else null end sexType
	,cast(cast(c1.kpu_dtroj as date) as varCHaR(10)) birthDate
	,c1.kpu_cdnlp taxCode
	,Kpu_TelM phoneMobile
	,Kpu_TelS phoneWorking
	,Kpu_Tel phoneHome
	,Kpu_EMail email
	,c1.kpu_fio description
	,c1. kpu_fio locName
	,cast(EXTRACT(DAY FROM c1.kpu_dtroj) as varCHaR(10)) dayBirthDate
	,cast(EXTRACT(MONTH FROM c1.kpu_dtroj) as varCHaR(10)) monthBirthDate
	,cast(EXTRACT(YEAR FROM c1.kpu_dtroj) as varCHaR(10)) yearBirthDate
from /*FIRM_SCHEMA*/dfirm001.kpux x1
inner join /*FIRM_SCHEMA*/dfirm001.KPUC1 c1 on c1.Kpu_Rcd = x1.kpu_rcd
inner join /*FIRM_SCHEMA*/dfirm001.KPUK1 k1 on k1.Kpu_Rcd = x1.kpu_rcd
/*SYSSTE_BEGIN*/
inner join ste1 on ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
where x1.kpu_tn < 4000000000
--	and { fn MOD( { fn TRUNCATE( Kpu_Flg / 64, 0 ) }, 2 ) } = 0
--	and (Kpu_Flg & 2) = 0	--
--	and x1.kpu_tnosn = 0
