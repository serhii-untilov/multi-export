-- Фізичні особи
select base.uuid_bigint(e1.id::text) "ID",
	base.no_structure_at(cast(now() as date), (staff.organization_by_staff_place_at(cast(now() as date),wp.id))) as "orgID",
	e1.ident_code "taxCode",
	e1.name_last "lastName",
	e1.name_first "firstName",
	e1.name_middle "middleName",
	case when e1.sex is true then 'M' else 'W' end "sexType",
	cast(cast(e1.birth_date as date) as varchar) "birthDate",
	concat(e1.name_last, ' ', substring(e1.name_first from 1 for 1), '. ', substring(e1.name_middle from 1 for 1), '.') "shortFIO",
	concat(e1.name_last, ' ', e1.name_first, ' ', e1.name_middle) "fullFIO",
	'NEW' state
from staff.employe e1
inner join staff.work_place wp on wp.keeper_id = e1.id and wp.to_date is null and wp.from_date is not null
	and wp.from_date = 
	(	select max(w2.from_date)
		from staff.work_place w2
		where w2.keeper_id = e1.id
		and w2.to_date is null and w2.from_date is not null
	)
where e1.deleted_at is null
order by e1.name_last;
