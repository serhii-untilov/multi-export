declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select
    pr_group_value.id as ID,
    people.Auto_Card as employeeID,
    1 as disabilityID,
    pr_group_value.string as disabilityGroup,
    CONVERT(nvarchar,pr_group_value.FromD,110) as dateFrom,
    CONVERT(nvarchar,pr_group_value.ToD,110) as dateTo,
    pr_group_value.Ndoc as docNumber,
    pr_group_value.Seria_Doc as docSeries,
    CONVERT(nvarchar,pr_group_value.Date,110) dateIssue,
    pr_group_value.text as workReference
FROM pr_group_value 
join people  ON people.Auto_Card = pr_group_value.id_ref
where id_group = 82
    and people.out_date = '1900-01-01'
    and people.sovm <> 2 
    and (@orgID is null or @orgID = people.id_Firm)









