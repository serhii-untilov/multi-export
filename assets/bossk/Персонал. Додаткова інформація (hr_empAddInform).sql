declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select pr_group_value.id as ID,
    people.Auto_Card as employeeID,
    pr_group_value.id_group as dictAddInfKindID,
    case when string + seria_doc+ndoc = ''
        then pr_group_value.text
        else string + ' ' + seria_doc + ' ' + ndoc
        end as strAddInform
FROM pr_group_value 
join people  ON people.Auto_Card = pr_group_value.id_ref
where id_group  <> 82
    and people.out_date = '1900-01-01'
    and (@orgID is null or @orgID = people.id_Firm)


