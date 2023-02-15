declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
SELECT 
	st.id as ID,
	st.auto_card as employeeID,
	st.vpr_wk_total_id_tot as dictExperienceID,
	cast(cast((dtend - delt) as date) as varchar) calcDate,
	case when dtend1 = GETDATE() + 10000 then '' else cast(cast(dtend1 as date) as varchar) end startCalcDate
FROM (
	SELECT
		st1.auto_card,
		st1.vpr_wk_total_id_tot,
		sum (
		case when st1.date_b<>st1.date_e  
		then DATEDIFF(day,st1.date_b,(case when st1.date_e between '1901-01-01' and GETDATE() then st1.date_e else GETDATE() end)) 
		else round( (Stag_Y*12+Stag_M)*30.4+Stag_D,0)
		end ) as delt,
		max (st1.id_tot_i) as id,
		max (case when st1.date_e between '1901-01-01' and GETDATE() then  st1.date_e else GETDATE() end) as dtend,
		max (case when st1.date_e between '1901-01-01' and GETDATE() then  st1.date_e else GETDATE() + 10000 end) as dtend1
	FROM PR_WK_TOTALS_I st1
    join people  ON people.Auto_Card = st1.Auto_Card 
	inner join vpr_wk_total d1 on d1.id_tot = st1.vpr_wk_total_id_tot
	where people.out_date = '1900-01-01 00:00:00.000'  and people.sovm <> 2 
	  and (@orgID is null or @orgID = people.id_Firm)
	group by st1.auto_card, st1.vpr_wk_total_id_tot
) st
