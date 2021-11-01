-- Категорії застрахованих осіб
select base.uuid_bigint(id::text) "ID",
	cast(category_worker as varchar) code, 
	name
from salary.tax;
