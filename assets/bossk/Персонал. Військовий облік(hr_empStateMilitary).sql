declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
SELECT durty_flg,
	military.Auto_Military as ID,
	military.Auto_Card as employeeID,
	military.code_sost as composition,
	case when code_sost in (1,2,6) then 1 else 
	case when code_sost in (3,8,9,15) then 2 else 
	case when code_sost in (7) then 3 else 
	case when code_sost in (4,11,12,13,14,16,18) then 4 else 
	case when code_sost in (5,10) then 5 else 
	case when code_sost in (17) then 6 else null
	end end end end end end as composition,
	(
		select min(Auto_Military) 
		FROM military mlt
		where Group_Uch <> '' 
			and mlt.Group_Uch = military.Group_Uch 
		group by Group_Uch
	)  as dictMilitaryGroupID, 
	(
		select min(Auto_Military) 
		FROM military mlt
		where categ <> '' 
			and  mlt.categ = military.Vus 
		group by categ
	) as dictCategMilitaryID,
	case when code_ord is null then '' when code_ord = 0 then '' else cast(code_ord as varchar) end as dictMilitaryRankID,
	(
		select min(Auto_Military) 
		FROM military mlt
		where vus <> '' 
			and  mlt.Vus = military.Vus 
		group by vus
	) as dictMilitarySpecialityID,
	case when rvk_place = '' then war_text else rvk_place end as office,
	case when durty_flg = 0 then 3 else durty_flg end as dictStateMilitaryID,  
	case when TypUdost_n=0 then null else 100 + TypUdost_n end as dictDocKindID,
	bilet_N as docNumber,
	condit as milSpecDescription,
	case when noarmy_flg=0 then null else noarmy_flg end as dictMilitarySuitableID,
	case when fromD <> '1900-01-01' then 'дата постановки на облік ' + cast(cast(fromD as date) as varchar)  else '' end as comment
	 

FROM military
join people ON people.Auto_Card = military.Auto_Card 
where people.out_date = '1900-01-01'
	and people.sovm <> 2
	and (@orgID is null or @orgID = people.id_Firm)


	
