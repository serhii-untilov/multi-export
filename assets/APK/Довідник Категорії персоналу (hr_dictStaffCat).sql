-- Довідник Категорії персоналу
select alias "ID",
	alias "code",
	name 
from staff.enum_work_post_category
order by alias;
