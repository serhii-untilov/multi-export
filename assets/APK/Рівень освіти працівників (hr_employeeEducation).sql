-- Рівень освіти працівників
select base.uuid_bigint(wp.id::text) "ID",
	base.uuid_bigint(e1.id::text) "employeeID",
	base.no_structure_at(cast(now() as date), (staff.organization_by_staff_place_at(cast(now() as date),wp.id))) as "orgID",
	base.uuid_bigint(staff.department_by_staff_place_at(cast(now() as date),wp.id)::text) as "departmentID",
	staff.no_by_staff_place_at(cast(now() as date), wp.id) "tabNum",
	e1.ident_code "taxCode",
	e1.name_last "lastName",
	e1.name_first "firstName",
	e1.name_middle "middleName",
	case when i1.education_type_id is not null then base.uuid_bigint(i1.education_type_id::text)::text else '' end as dictDegreeID -- образование (код)
from staff.work_place wp
inner join staff.employe e1 on wp.keeper_id = e1.id 
inner join staff.info_staff i1 on i1.employe_owner_id = e1.id
where e1.deleted_at is null
and wp.to_date is null and wp.from_date is not null
and i1.education_type_id is not null
and i1.deleted_at is null
order by e1.name_last;
