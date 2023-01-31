declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
SELECT id_h as ID,
	id_h as code,
	healf as name  
FROM military_healf
where id_h in (
	SELECT distinct noarmy_flg
	FROM military
	join people ON people.Auto_Card = military.Auto_Card 
	where people.out_date = '1900-01-01'
		and people.sovm <> 2
		and (@orgID is null or @orgID = people.id_Firm)
)
