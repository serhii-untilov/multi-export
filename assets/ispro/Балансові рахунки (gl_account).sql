-- Балансові рахунки (gl_account)
-- Увага! Запит виконується довго тому що вибираються тільки рахунки які використовуються у зарплаті для формування проводок, не у самих проводках. 
-- Цього достатньо для виконання імпорту картотек "Призначення", "Архів розрахункових листів", "Архів нарахувань на зарплату".
-- Проводки не імпортуються.
-- План рахунків не імпортується і повинен бути готовим до початку імпорту
-- Отриманий файл Балансові рахунки (gl_account.csv) також не імпортується, використовується тільки для настройки Таблиці відповідності
-- На базі Охматдит час виконання - 8 - 12 хвилин.
/*BEGIN-OF-HEAD*/
select 'ID', 'code', 'name', 'description'
union all
/*END-OF-HEAD*/
select 
	cast(sprpls_rcd as varchar) ID	
	,sprpls_sch code	
	,sprpls_nm name	
	,sprpls_sch + ' ' + sprpls_nm description	
from sprpls p1
where sprpls_rcd in (
	select distinct KpuPrkz_Sch
	from kpuprk1
	where KpuPrkz_Sch <> 0
/*
	union
	select distinct kpurl_cdsch
	from kpurlospz
	where kpurl_cdsch <> 0
	union
	select distinct KpuF_CdSch
	from kpufa1
	where kpuf_cdsch <> 0
*/
)	