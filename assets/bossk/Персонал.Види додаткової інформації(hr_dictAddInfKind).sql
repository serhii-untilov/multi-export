select distinct pr_group.id as ID,
pr_group.id as code,
pr_group.name as name
FROM pr_group
join pr_group_value on pr_group.id = pr_group_value.id_group
where id_group <> 82
order by id