-- Паспорт
select base.uuid_bigint(wp.id::text) "ID",
	base.uuid_bigint(e1.id::text) "employeeID",
	base.no_structure_at(cast(now() as date), (staff.organization_by_staff_place_at(cast(now() as date),wp.id))) as "orgID",
	base.uuid_bigint(staff.department_by_staff_place_at(cast(now() as date),wp.id)::text) as "departmentID",
	staff.no_by_staff_place_at(cast(now() as date), wp.id) "tabNum",
	e1.ident_code "taxCode",
	e1.name_last "lastName",
	e1.name_first "firstName",
	e1.name_middle "middleName",
    '1' dictDocKindID,
    coalesce(ps.series, '') docSeries,
    ps.no docNumber,
    coalesce(ps.issued_by, '') docIssued,
    coalesce(cast(cast(ps.issued_at as date) as varchar), '') docIssuedDate,
    concat('Паспорт', case when length(ps.series) > 0 then  ' ' else '' end, ps.series, case when length(ps.no) > 0 then ' ' else '' end, ps.no) description
from staff.work_place wp
inner join staff.employe e1 on wp.keeper_id = e1.id 
inner join base.info_pasport ps on ps.person_owner_id=e1.id
where e1.deleted_at is null
and wp.to_date is null and wp.from_date is not null
and ps.deleted_at is null
order by e1.name_last;
