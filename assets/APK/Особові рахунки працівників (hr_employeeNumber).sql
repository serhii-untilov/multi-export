-- Особові рахунки працівників
select base.uuid_bigint(h1.id::text) "ID",
	base.uuid_bigint(e1.id::text) "employeeID"
	,base.uuid_bigint((case when dt2.name = 'Організація' then dh2.owner_structure_id when dt3.name = 'Організація' then dh3.owner_structure_id else null end)::text) as "orgID"
	,base.uuid_bigint(h1.department_id::text) "departmentID",	
	h1.employe_no "tabNum",
	e1.ident_code "taxCode",
	e1.name_last "lastName",
	e1.name_first "firstName",
	e1.name_middle "middleName",
	cast(cast(wp.from_date as date) as varchar) "dateFrom",
	'' "dateTo" --cast(cast(d1.from_date as date) as varchar) "dateTo"
	,'' "payOutID"
	,'' "personalAccount"
	,cast(cast(h1.from_date as date) as varchar) "appointmentDate"
	,cast(cast(h1.issued_at as date) as varchar) "appointmentOrderDate"
	,h1.no "appointmentOrderNumber"
	,concat(e1.name_last, ' ', e1.name_first, ' ', e1.name_middle, ' [', h1.employe_no, ']') "description"
from staff.employe e1
inner join staff.doc_hiring h1 on h1.employe_id = e1.id
left join staff.info_staff i1 on i1.employe_owner_id = e1.id
inner join staff.work_place wp on wp.keeper_id = e1.id
left join staff.doc_dismissal d1 on d1.id = wp.doc_dismissal_id
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
	and h1.deleted_at is null
	and h1.active 
	and d1.from_date is null
order by e1.name_last;
