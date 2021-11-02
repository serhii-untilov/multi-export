-- Особові рахунки працівників
select base.uuid_bigint(wp.id::text) "ID",
	base.uuid_bigint(e1.id::text) "employeeID",
	base.no_structure_at(cast(now() as date), (staff.organization_by_staff_place_at(cast(now() as date),wp.id))) as "orgID",
	base.uuid_bigint(staff.department_by_staff_place_at(cast(now() as date),wp.id)::text) as "departmentID",
	staff.no_by_staff_place_at(cast(now() as date), wp.id) "tabNum",
	e1.ident_code "taxCode",
	e1.name_last "lastName",
	e1.name_first "firstName",
	e1.name_middle "middleName",
	cast(cast(wp.from_date as date) as varchar) "dateFrom",
	'9999-12-31' "dateTo"
	,'' "payOutID"
	,'' "personalAccount"
	,concat(e1.name_last, ' ', e1.name_first, ' ', e1.name_middle, ' [', staff.no_by_staff_place_at(cast(now() as date), wp.id), ']') "description"
from staff.work_place wp
left join staff.employe e1 on wp.keeper_id = e1.id 
left join staff.info_staff i1 on i1.employe_owner_id = e1.id
where 1=1
and e1.deleted_at is null
and wp.to_date is null and wp.from_date is not null
order by e1.name_last;
