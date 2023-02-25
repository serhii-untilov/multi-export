declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select *
from (
	select pr_group_value.id ID,
		people.Auto_Card employeeID,
		pr_group_value.id_group dictAddInfKindID,
		case when len(coalesce(string, '') + coalesce(seria_doc, '') + coalesce(ndoc, '')) = 0
			then pr_group_value.text
		else rtrim(ltrim(coalesce(string, '') + ' ' + coalesce(seria_doc, '') + ' ' + coalesce(ndoc, '')))
		end as strAddInform
	FROM pr_group_value
	join people ON people.Auto_Card = pr_group_value.id_ref
	where id_group <> 82
		and people.out_date = '1900-01-01'
		and (@orgID is null or @orgID = people.id_Firm)
) t1
where strAddInform is not null
