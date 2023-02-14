select distinct 100+TypUdost_n as ID, 100+TypUdost_n as code, TypUdost.name as name
FROM military
  join TypUdost on rtrim(ltrim(military.TypUdost_n))=rtrim(ltrim(TypUdost.n))

 Union

 select 1 as ID,
 1 as code,
 'Паспорт' as name

Union

 select 2 as ID,
 2 as code,
 'Трудова книжка' as name
 
 Union

 select 3 as ID,
 3 as code,
 'Диплом про освіту' as name