-- Довідник Графіки роботи
select ROW_NUMBER () OVER (ORDER BY id, work_period_time) "ID"
,case when work_period_time is null then name else work_period_time::text end "code"
,case when work_period_time is null then name else concat(name, ' ', work_period_time::text, ' год.') end "name"
,description
,coalesce(cast(cast(from_date as date) as varchar), '') "dateFrom"
--,id sheet_template_id
--,coalesce(work_period_time, 0) work_period_time
from (
	select distinct t1.id, t1.name, h1.work_period_time, t1.description, t1.from_date 
	from staff.doc_hiring h1
	left join sheet.sheet_template t1 on t1.id = h1.sheet_template_id
) t1;