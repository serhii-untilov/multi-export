-- Довідник графіків роботи
select distinct 
	NULLIF(regexp_replace(p1.work_period_time::text, '\D','','g'), '') "ID",
	p1.work_period_time::text "code",
	p1.work_period_time::text "name"
from staff.dict_work_post p1
where p1.deleted_at is null
and p1.work_period_time is not null
order by p1.work_period_time::text;
