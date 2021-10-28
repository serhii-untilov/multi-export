-- Джерело фінансування (ac_fundSource).csv
select base.uuid_bigint(id::text) "ID",
    code,
    name
from salary.ctlg_salary_source
where deleted_at is null
order by code;