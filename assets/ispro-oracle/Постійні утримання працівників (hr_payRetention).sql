-- Постійні утримання працівників (hr_payRetention)
select
	u1.KpuUdr_Id "ID"
	,x1.kpu_tn "tabNum"
	,u1.kpu_rcd "employeeNumberID"
	,TO_CHAR(u1.kpuUdr_datn, 'YYYY-MM-DD') "dateFrom"
	,case 
		when u1.kpuUdr_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '9999-12-31' 
		else TO_CHAR(u1.kpuUdr_datk, 'YYYY-MM-DD') 
		end "dateTo"
	,u1.kpuudr_cd "payElID"
	,case 
		when BITAND(KpuUdr_Prz, 1) <> 0 then '' 
		else TO_CHAR(u1.kpuUdr_Sm / power(10, kpuudr_mt)) 
		end "baseSum"
	,case 
		when BITAND(KpuUdr_Prz, 1) = 0 then ''
		-- ����� �� ��������� �� 1-� �������� ������ � 100% - �������� ������� (UBHR-7785)
		when v1.vo_met = 61 and BITAND(v1.vo_prz, 16) <> 0 and (u1.kpuUdr_Sm / power(10, kpuudr_mt)) = 100 then ''
		else TO_CHAR(u1.kpuUdr_Sm / power(10, kpuudr_mt)) 
		end "rate"
	,case when KpuUdrPlc_Typ = 1 then '2' -- ����
		when KpuUdrPlc_Typ = 3 then '1' -- ����
		when KpuUdrPlc_Typ = 4 then '1' -- �������� - ����
		when KpuUdrPlc_Typ = 2 then '3' -- �����
		else '1' 
		end "paymentMethod" -- ����
	,s1.ptnsch_bcd" bankID"
	,case 
		when v1.vo_met = 19 and length(KpuUdr_DatRRFio) > 0 then TO_CHAR(u1.kpuudr_ID) 
		else '' 
		end "employeeFamilyID"
	,u1.KpuUdr_Dolg / 100 "debtSum"
	,u1.KpuUdr_Rest / 100 "remindSum"
	,case 
		when u1.KpuUdr_Idx <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '' 
		else TO_CHAR(u1.KpuUdr_Idx, 'YYYY-MM-DD') 
		end "dateIdxFrom"
	,case 
		when u1.kpuudr_dtpr <= TO_DATE('1876-12-31', 'YYYY-MM-DD') then '' 
		else TO_CHAR(u1.kpuudr_dtpr, 'YYYY-MM-DD') 
		end "docDate"
	,case 
		when length(u1.kpuudr_cdpr) = 0 then '' 
		else u1.kpuudr_cdpr 
		end "docNumber"
	,k1.Ptn_Rcd "contractorID"
	,case when s1.bookmark is null then '' else TO_CHAR(s1.bookmark) end "contrAccountID"	
	,case when length(kpuudr_ls) = 0 then '' else kpuudr_ls end "personalAccount"
from /*FIRM_SCHEMA*/ISPRO_8_PROD.KPUUDR1 u1
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpuc1 c1 on c1.kpu_rcd = u1.kpu_rcd
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.kpux x1 on x1.kpu_rcd = u1.kpu_rcd
inner join /*FIRM_SCHEMA*/ISPRO_8_PROD.payvo1 v1 on v1.vo_cd = u1.kpuudr_cd
/*SYSSTE_BEGIN*/
JOIN (
    SELECT MAX(sysste_rcd) AS sysste_rcd
    FROM /*FIRM_SCHEMA*/ISPRO_8_PROD.sysste
    WHERE sysste_cd = /*SYSSTE_CD*/'1500'
) ste1 ON ste1.sysste_rcd = c1.kpuc_se
/*SYSSTE_END*/
left join /*FIRM_SCHEMA*/ISPRO_8_PROD.PtnSchk s1 on s1.ptn_rcd = u1.kpuudr_cdplc and s1.ptnsch_rcd = u1.kpuudr_cdbank
left join /*FIRM_SCHEMA*/ISPRO_8_PROD.PtnRk k1 on k1.Ptn_Rcd = u1.kpuudr_cdplc
where BITAND(c1.kpu_flg, 2) = 0
	and (kpuudr_datk <= TO_DATE('1876-12-31', 'YYYY-MM-DD') 
		or kpuudr_datk >= ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -12), 'YEAR'), -3))
