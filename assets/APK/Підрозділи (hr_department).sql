-- Підрозділи
select base.uuid_bigint(d1.id::text) "ID",
    base.uuid_bigint((case when t2.name = 'Організація' then h2.owner_structure_id when t3.name = 'Організація' then h3.owner_structure_id else null end)::text) as "orgID",
    trim(coalesce(NULLIF(regexp_replace(h1.short_name, '\D','','g'), ''), left(concat(NULLIF(regexp_replace(s1.short_name, '\D','','g'), ''), ' ', right(h1.short_name, 16)), 16))) code,
    h1.short_name "name",
    h1.long_name "fullName",
    case when s1.id is not null then base.uuid_bigint(s1.id::text) else null end as "parentUnitID",
    cast(cast(h1.from_date as date) as varchar) "dateFrom",
    case when h1.close_date is not null then cast(cast(h1.close_date as date) as varchar) else '' end "dateTo"
from base.department d1
inner join base.info_dep_history h1 on h1.owner_structure_id = d1.id
left join base.info_structure_history s1 on s1.owner_structure_id = h1.parent_structure_id
inner join base.dict_structure_type t1 on t1.id = h1.structure_type_id
left join base.info_structure_history h2 on h2.owner_structure_id = h1.parent_structure_id
left join base.dict_structure_type t2 on t2.id = h2.structure_type_id
left join base.info_structure_history h3 on h3.owner_structure_id = h2.parent_structure_id
left join base.dict_structure_type t3 on t3.id = h3.structure_type_id
where d1.deleted_at is null
order by h1.short_name;
