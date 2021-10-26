-- Призначення працівників
-- select * from staff.employe
-- select * from staff.doc_hiring
-- select * from staff.info_staff
-- select * from staff.work_place
-- select * from staff.doc_dismissal
-- select * from staff.dict_work_post where id = '1ca3e1b7-1c18-4685-af53-1bb97c89b276'
select base.uuid_bigint(h1.id::text) "ID",
	base.uuid_bigint(e1.id::text) "employeeID",
	h1.employe_no "tabNum",
	e1.ident_code "taxCode",
	e1.name_last "lastName",
	e1.name_first "firstName",
	e1.name_middle "middleName",
	cast(cast(h1.from_date as date) as varchar) "dateFrom",
	'' "dateTo" --cast(cast(d1.from_date as date) as varchar) "dateTo"
	,cast(cast(h1.from_date as date) as varchar) "appointmentDate"
	,cast(cast(h1.issued_at as date) as varchar) "appointmentOrderDate"
	,h1.no "appointmentOrderNumber"
	,concat(e1.name_last, ' ', e1.name_first, ' ', e1.name_middle, ' [', h1.employe_no, ']') "description"
	,base.uuid_bigint(h1.structure_id::text) "orgID"
	,base.uuid_bigint(h1.department_id::text) "departmentID"
	,base.uuid_bigint(h1.work_post_type_id::text) "dictPositionID"
	,case when h1.work_period_time is NULL then '40' else regexp_replace(h1.work_period_time::text, '\D','','g') end "workScheduleID"
from staff.employe e1
inner join staff.doc_hiring h1 on h1.employe_id = e1.id
left join staff.info_staff i1 on i1.employe_owner_id = e1.id
inner join staff.work_place wp on wp.keeper_id = e1.id
left join staff.doc_dismissal d1 on d1.id = wp.doc_dismissal_id 
where e1.deleted_at is null
and h1.deleted_at is null
and h1.active 
and d1.from_date is null
order by h1.employe_no;
