select ID, ROW_NUMBER()  OVER (ORDER BY name) as code, name 
from (
  select min(Auto_Military) as ID,
         Categ as name
  FROM military
  where Categ<>''
  group by Categ
) t1