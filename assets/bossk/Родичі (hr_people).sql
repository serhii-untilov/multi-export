declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select 
	pr_rel_num ID
	,child.auto_card employeeID
	,Who_Code dictKinshipKindID
	,ltrim(rtrim(child.name_i)) firstName
	,case when ltrim(rtrim(child.name)) = '' then ltrim(rtrim(empl.name)) else ltrim(rtrim(child.name)) end lastName
	,ltrim(rtrim(child.name_o)) middleName
	,(case when ltrim(rtrim(child.name)) = '' then ltrim(rtrim(empl.name)) else ltrim(rtrim(child.name)) end) + ' ' + ltrim(rtrim(child.name_i)) + ' ' + ltrim(rtrim(child.name_o)) shortFIO
	,(case when ltrim(rtrim(child.name)) = '' then ltrim(rtrim(empl.name)) else ltrim(rtrim(child.name)) end) + ' ' + ltrim(rtrim(child.name_i)) + ' ' + ltrim(rtrim(child.name_o)) fullFIO
	,case 
		when child.Date_birth is null then ''
		when child.Date_birth in ('1900-01-01', '2099-01-01') then ''
		else cast(cast(child.Date_birth as date) as varchar) 
	end birthDate
from PR_RELATIV child
inner join card empl ON child.Auto_Card = empl.Auto_Card 
inner join people ON people.Auto_Card = empl.Auto_Card 
where people.out_date in ('1900-01-01', '2099-01-01')
	and (@orgID is null or @orgID = people.id_Firm)
	and people.sovm <> 2