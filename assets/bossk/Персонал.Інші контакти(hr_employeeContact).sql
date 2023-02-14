declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ªÄÐÏÎÓ', '' - óñ³ îðãàí³çàö³¿
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)

SELECT
pr_phones.id as ID,
people.Auto_Card as employeeID,
pr_phones.phone_type_code as contactTypeID,
pr_phones.value as value

from pr_phones 
  join people  ON people.Auto_Card = pr_phones.Auto_Card 
 where people.out_date = '1900-01-01' 
 and people.sovm <> 2
 and pr_phones.value <> ''
  and (@orgID is null or @orgID = people.id_Firm)

 
