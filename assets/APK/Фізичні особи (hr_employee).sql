--  Фізичні особи
select 
	base.uuid_bigint(id::text) "ID",
	ident_code "taxCode",
	name_last "lastName",
	name_first "firstName",
	name_middle "middleName",
	case when sex is true then 'M' else 'W' end "sexType",
	cast(cast(birth_date as date) as varchar) "birthDate",
	concat(name_last, ' ', substring(name_first from 1 for 1), '. ', substring(name_middle from 1 for 1), '.') "shortFIO",
	concat(name_last, ' ', name_first, ' ', name_middle) "fullFIO",
	'NEW' state
from staff.employe; --base.dict_person;