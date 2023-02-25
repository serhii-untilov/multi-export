declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select
    c1.Auto_Card ID
    ,left(ltrim(rtrim(coalesce(Name, ''))), 30) lastName
    ,left(ltrim(rtrim(coalesce(Name_i, ''))), 30) firstName
    ,left(ltrim(rtrim(coalesce(Name_o, ''))), 30) middleName
    ,left(ltrim(rtrim(coalesce(Full_Name, ''))), 512) fullFIO
    ,case when Sex = 0 then 'M' when Sex = 1 then 'W' else '' end sexType
    ,cast(cast(Date_birth as date) as varchar) birthDate
    ,Citizenship citizenshipID
    ,case when FamilyStatus is null or FamilyStatus = 0 then '' else cast(FamilyStatus as varchar) end dictMaritalStatusKindID
    ,(case when bAddr_Region is null or rtrim(ltrim(bAddr_Region)) = '' then '' else bAddr_Region end) +
    (case when bAddr_City is null or rtrim(ltrim(bAddr_City)) = '' then '' else ((case when (bAddr_Region is null or rtrim(ltrim(bAddr_Region)) = '') then '' else ', ' end)) + bAddr_City end) +
    (case when Addr_okrug is null or rtrim(ltrim(Addr_okrug)) = '' then '' else (case when bAddr_City is null or rtrim(ltrim(bAddr_City)) = '' then '' else ', ' end) + Addr_okrug + ' �-�' end) birthPlace
    ,case when INN is not null then 'TAXCODE'  else 'PASSPORT' end empTaxCodeType
    ,ltrim(rtrim(coalesce(INN, coalesce(Passp_ser, '') + coalesce(Passp_num, ''))))  taxCode
    ,1 as dictTaxCodeReasonID
    ,left(ltrim(rtrim(coalesce(EMail, ''))), 50) email
    ,'NEW' state
    ,left(replace(rtrim(ltrim(coalesce(mob_tel.value, ''))), ' ', ''), 20) phoneMobile
    ,left(replace(rtrim(ltrim(coalesce(dom_tel.value, ''))), ' ', ''), 20) phoneHome
    ,left(replace(rtrim(ltrim(coalesce(rab_tel.value, ''))), ' ', ''), 20) phoneWorking
from Card c1
left join (
	SELECT Auto_Card, value 
	FROM phone_types p1, pr_phones p2 
	where p1.phone_type_code = p2.phone_type_code
        and p1.phone_type_code = 474
        and tod > GETDATE()
        and IsDefault=1
) mob_tel ON mob_tel.Auto_Card = c1.Auto_Card 
left join (
	SELECT Auto_Card, value FROM phone_types p1, pr_phones p2 
    where p1.phone_type_code = p2.phone_type_code
		and p1.phone_type_code = 471
        and tod > GETDATE()
        and IsDefault=1
) dom_tel ON dom_tel.Auto_Card = c1.Auto_Card 
left join (
	SELECT Auto_Card, value 
	FROM phone_types p1, pr_phones p2
	where p1.phone_type_code = p2.phone_type_code
        and p1.phone_type_code = 478
        and tod > GETDATE()
        and IsDefault=1
) rab_tel ON rab_tel.Auto_Card = c1.Auto_Card
left join (
	SELECT Auto_Card, value 
	FROM phone_types p1, pr_phones p2 
    where p1.phone_type_code = p2.phone_type_code
		and p1.phone_type_code = 476
        and tod > GETDATE()
        and IsDefault=1
) mail ON mail.Auto_Card = c1.Auto_Card
where c1.Auto_Card in (
	select distinct p1.Auto_Card
	from people p1
	where (@orgID is null or @orgID = p1.id_Firm)
)
order by Full_Name
