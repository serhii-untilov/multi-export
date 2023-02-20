select 
    phone_type_code as ID,
    phone_type_code as code,
    phone_type_name as name
from phone_types
union
select 
    999 as ID,
    т999 as code,
    'Внуренний' as name