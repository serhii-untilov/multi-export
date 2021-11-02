-- Призначення працівників
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
	'9999-12-31' "dateTo",
	concat(e1.name_last, ' ', e1.name_first, ' ', e1.name_middle, ' [', staff.no_by_staff_place_at(cast(now() as date), wp.id), ']') "description",
	base.uuid_bigint(h1.work_post_type_id::text) "dictPositionID",
	t2."workScheduleID" "workScheduleID",
	case when salary.salary_source_by_staff_place_at(cast(now() as date), wp.id) is not null then base.uuid_bigint(salary.salary_source_by_staff_place_at(cast(now() as date), wp.id)::text)::text else '' end "dictFundSourceID",
	case when staff.tax_by_work_place_at(cast(now() as date),wp.id) is not null then base.uuid_bigint(staff.tax_by_work_place_at(cast(now() as date),wp.id)::text)::text else '' end dictCategoryECBID
from staff.work_place wp
left join staff.employe e1 on wp.keeper_id = e1.id 
left join staff.info_staff i1 on i1.employe_owner_id = e1.id
---
left join staff.doc_hiring h1 on h1.employe_id = e1.id and h1.from_date = wp.from_date and h1.deleted_at is null
left join (
-- Довідник Графіки роботи
	select ROW_NUMBER () OVER (ORDER BY id, work_period_time) "workScheduleID"
	,case when work_period_time is null then name else work_period_time::text end "code"
	,case when work_period_time is null then name else concat(name, ' ', work_period_time::text, ' год.') end "name"
	,description
	,cast(cast(from_date as date) as varchar) "dateFrom"
	,id sheet_template_id
	,coalesce(work_period_time, 0) work_period_time
	from (
		select distinct t1.id, t1.name, h1.work_period_time, t1.description, t1.from_date 
		from staff.doc_hiring h1
		left join sheet.sheet_template t1 on t1.id = h1.sheet_template_id
	) t1
) t2 on t2.sheet_template_id = h1.sheet_template_id and t2.work_period_time = coalesce(h1.work_period_time, 0)
---
where e1.deleted_at is null
and wp.to_date is null and wp.from_date is not null
order by e1.name_last;
