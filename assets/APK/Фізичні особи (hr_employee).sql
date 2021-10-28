-- Фізичні особи
select 
	base.uuid_bigint(e1.id::text) "ID",
	base.uuid_bigint((case when dt2.name = 'Організація' then dh2.owner_structure_id when dt3.name = 'Організація' then dh3.owner_structure_id else null end)::text) as "orgID",
	e1.ident_code "taxCode",
	e1.name_last "lastName",
	e1.name_first "firstName",
	e1.name_middle "middleName",
	case when e1.sex is true then 'M' else 'W' end "sexType",
	cast(cast(e1.birth_date as date) as varchar) "birthDate",
	concat(e1.name_last, ' ', substring(e1.name_first from 1 for 1), '. ', substring(e1.name_middle from 1 for 1), '.') "shortFIO",
	concat(e1.name_last, ' ', e1.name_first, ' ', e1.name_middle) "fullFIO",
	'NEW' state
from staff.employe e1 --base.dict_person;
inner join staff.doc_hiring h1 on h1.employe_id = e1.id
---
left join base.info_dep_history dh1 on dh1.owner_structure_id = h1.department_id
left join base.info_structure_history ds1 on ds1.owner_structure_id = dh1.parent_structure_id
left join base.dict_structure_type dt1 on dt1.id = dh1.structure_type_id
left join base.info_structure_history dh2 on dh2.owner_structure_id = dh1.parent_structure_id
left join base.dict_structure_type dt2 on dt2.id = dh2.structure_type_id
left join base.info_structure_history dh3 on dh3.owner_structure_id = dh2.parent_structure_id
left join base.dict_structure_type dt3 on dt3.id = dh3.structure_type_id
---
where e1.deleted_at is null
order by e1.name_last;
