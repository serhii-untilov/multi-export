select ID, ROW_NUMBER( )  OVER ( ORDER BY name ) as code, name 
from (
  select min(Auto_Military) as ID,
         Group_Uch as name
  FROM military
  where Group_Uch<>''
  group by Group_Uch) t1
