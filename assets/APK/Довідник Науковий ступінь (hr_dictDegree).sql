-- Науковий ступінь
select base.uuid_bigint(id::text) "ID",
	alias "code",
	name
from staff.enum_education_type;