-- Пільги ПДФО працівників
select base.uuid_bigint(wp.id::text) "ID",
	base.uuid_bigint(e1.id::text) "employeeID",
	base.no_structure_at(cast(now() as date), (staff.organization_by_staff_place_at(cast(now() as date),wp.id))) as "orgID",
	base.uuid_bigint(staff.department_by_staff_place_at(cast(now() as date),wp.id)::text) as "departmentID",
	staff.no_by_staff_place_at(cast(now() as date), wp.id) "tabNum",
	e1.ident_code "taxCode",
	e1.name_last "lastName",
	e1.name_first "firstName",
	e1.name_middle "middleName",
	base.uuid_bigint(wb.tax_bonus_id::text) "taxLimitID",
	coalesce(cast(cast(wp.from_date as date) as varchar), '') "dateFrom",
	coalesce(cast(cast(wp.to_date as date) as varchar), '9999-12-31') "dateTo",
	case when db.alias = '15' then '1'
		when db.alias = '15/2' then '1' 
		when db.alias = '2' then '1'
		when db.alias = '2/1' then '2'
		when db.alias = '2/2' then '3'
		when db.alias = '2/3' then '4'
		when db.alias = '2/4' then '5'
		when db.alias = '3' then '1'
		when db.alias = '4' then '2'
		when db.alias = '4/2' then '3'
		when db.alias = '4/4' then '4'
		else '' end "amountChild"
from staff.work_place wp
inner join staff.employe e1 on wp.keeper_id = e1.id 
inner join salary.info_work_place_tax_bonus wb on wb.work_place_owner_id = wp.id
inner join salary.tax_bonus db on db.id = wb.tax_bonus_id
where e1.deleted_at is null
and wp.to_date is null and wp.from_date is not null
and wb.deleted_at is null
and db.deleted_at is null
order by e1.name_last;
