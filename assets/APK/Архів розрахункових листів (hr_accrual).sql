-- Архів розрахункових листів
-- Тільки нарахування, для розрахунку середнього заробітку
select base.uuid_bigint(s1.id::text) "ID",
	base.uuid_bigint(wp.id::text) "employeeNumberID",
	base.no_structure_at(cast(now() as date), (staff.organization_by_staff_place_at(cast(now() as date),wp.id))) as "orgID",
	staff.no_by_staff_place_at(cast(now() as date), wp.id) "tabNum",
	e1.ident_code "taxCode",
	e1.name_last "lastName",
	e1.name_first "firstName",
	e1.name_middle "middleName",
	concat(left(s1.salary_period::text, 4), '-', substring(s1.salary_period::text from 5 for 2), '-', right(s1.salary_period::text, 2)) "periodCalc",
	concat(left(s1.record_period::text, 4), '-', substring(s1.record_period::text from 5 for 2), '-', right(s1.record_period::text, 2)) "periodSalary",
	base.uuid_bigint(s1.income_article_id::text) "payElID",
	s1.sum "paySum",
	case when s1.salary_source_id is not null then base.uuid_bigint(s1.salary_source_id::text)::text else '' end "dictFundSourceID",
	cast(s1.begin_date as date)::text "dateFrom",
	cast(s1.end_date as date)::text "dateTo",
	case when s1.norm_days is null then '' when s1.norm_days = 0 then '' else s1.norm_days::text end "planDays",
	case when s1.norm_hours is null then '' when s1.norm_hours = 0 then '' else s1.norm_hours::text end "planHours",
	case when s1.def_value is null then '' when s1.def_value = 0 then '' else trunc(cast(s1.def_value as numeric), 2)::text end "baseSum",
	case when s1.work_days is null then '' when s1.work_days = 0 then '' else s1.work_days::text end "days",
	case when s1.work_hours is null then '' when s1.work_hours = 0 then '' else trunc(cast(s1.work_hours as numeric), 2)::text end "hours",
	case when s1."percent" is null then '' when s1."percent" = 0 then '' else (s1."percent")::text end "rate",
	case when s1.avg_sum is null then '' when s1.avg_sum = 0 then '' else trunc(cast(s1.avg_sum as numeric), 2)::text end "sumAvg"
from salary.reg_salary_income s1
inner join staff.work_place wp on wp.id = s1.work_place_id 
left join staff.employe e1 on wp.keeper_id = e1.id 
where e1.deleted_at is null
and wp.to_date is null and wp.from_date is not null
and to_date(s1.salary_period::text, 'YYYYMMDD') >= date_trunc('year', now()) - interval '1 year'
order by e1.name_last;
