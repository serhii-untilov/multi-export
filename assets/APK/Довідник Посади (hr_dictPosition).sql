-- Довідник посад
select base.uuid_bigint(p1.id::text) "ID",
	p1.code "code",
	left(case when p1.description is not null then concat(p1.name, ', ', p1.description) else p1.name end, 256) "name",
	left(p1.name_kp, 256) "fullName",
	NULLIF(regexp_replace(p1.code, '\D','','g'), '') "dictProfessionID",
	p1.code "dictProfessionCode",
	p1.code_zk "dictProfessionZKPPTR",
	NULLIF(regexp_replace(p1.work_period_time::text, '\D','','g'), '') "workScheduleID",
	nullif(c1.alias, '') "dictStaffCatID",
	left(case when p1.description is not null then concat(p1.name, ', ', p1.description) else p1.name end, 256) "description",
	left(case when p1.code is not null then concat(p1.name, '[', p1.code, ']') else p1.name end, 256) "caption", 
	p1.work_period_time "weekHours"
from staff.dict_work_post p1
left join staff.enum_work_post_category c1 on c1.id = p1.work_post_category_id 
where p1.deleted_at is null
order by p1.name;
