select ID, ROW_NUMBER()  OVER (ORDER BY name) as code, name 
from (
       select min(Auto_Military) as ID, Vus as name
       FROM military
       where vus <> ''
       group by vus
) t1

