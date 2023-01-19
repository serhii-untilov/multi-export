select 
    cast(Code_Pay as varchar) ID
    ,cast(Code_Pay as varchar) code
    ,Name_Pay name
from typ_Pay
where Code_Pay > 0 
and Name_Pay <> ''
-- and Activ <> 0
and Code_Pay in (
    select distinct Code_Pay from Lic
    union
    select distinct Code_Pay from const_uder
    union
    select distinct Code_Pay from const_pay
    union
    select distinct Code_SysPay from PR_CURRENT
)
order by Code_Pay
