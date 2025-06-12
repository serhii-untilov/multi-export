-- Нарахування на зарплату (hr_payFund)
select
	payfnd_rcd "ID"
	,payfnd_cd "code"
	,pspr.spr_nm "name"
	,TO_CHAR(payfnd_datn, 'YYYY-MM-DD') "dateFrom"
	,case when payfnd_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '9999-12-31' else TO_CHAR(payfnd_datk, 'YYYY-MM-DD') end "dateTo"
	,'SALARY' "calcPeriod" -- !!!
	,case when payfnd_stt = 16 then floor(payfnd_limit) else 0 end "sequence"
	,case when payfnd_noclc = 0 then 1 else 0 end "isAutoCalc"
	,case when payfnd_noreclc = 0 then 1 else 0 end "isRecalculate"
	,payfnd_stt "payFundMethodID"
	,'' "typeTaxECBID"
	,payfnd_cd || ' ' || pspr.spr_nm "description"
	,'' "entryOperationID"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.PayFnd f1
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.PSPR on pspr.SprSpr_Cd = 133644 
	and pspr.Spr_Cd = f1.payfnd_rcd
where PayFnd_Del = 0
	and (payfnd_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		or payfnd_datk > ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3))
--	or exists (
--		select null
--		from KPUFA1 k1
--		where k1.KpuF_CdFnd = f1.payfnd_rcd
--		and kpuf_datup >= @dateFrom
--	)