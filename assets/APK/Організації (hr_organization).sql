-- Організації
SELECT base.uuid_bigint(o1.id::text)::text "ID",
    NULLIF(regexp_replace(h1.short_name, '\D','','g'), '') code,
    h1.short_name "name", 
    h1.long_name "fullName",
    case when h2.owner_structure_id is not null then base.uuid_bigint(h2.owner_structure_id::text)::text else '' end "parentUnitID"
FROM base.organization o1
inner join base.info_structure_history h1 on h1.owner_structure_id = o1.id
inner join base.dict_structure_type t1 on t1.id = h1.structure_type_id 
left join base.info_structure_history h2 on h2.owner_structure_id = h1.parent_structure_id 
where o1.deleted_at is null
order by h1.short_name;
