declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select 
	Code ID,
	Code code,
	left(comment, 100) name,
	cast(Code as varchar) docType
from TypUdost 
where Code in (
select distinct t1.Code
from card 
inner join people  ON people.Auto_Card = card.Auto_Card 
left join TypUdost t1 on t1.Code = TypUdost
where people.out_date = '1900-01-01'
	and people.sovm <> 2
	and (@orgID is null or @orgID = people.id_Firm)
)
union

select distinct 
    100+TypUdost_n as ID, 
	100+TypUdost_n as code, 
	TypUdost.name as name,
	'' docType
FROM military
  join TypUdost on rtrim(ltrim(military.TypUdost_n))=rtrim(ltrim(TypUdost.n))

union
select 109 ID,
	109 code,
	'Закордонний паспорт' name,
	'1' docType
union
select 119 ID,
	119 code,
	'Свідоцтво про освіту' name,
	'' docType
