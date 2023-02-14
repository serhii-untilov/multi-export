declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select
    c1.Auto_Card ID
	,c1.Auto_Card as employeeID
    ,left(ltrim(rtrim(coalesce(Name, ''))), 30) lastName
    ,left(ltrim(rtrim(coalesce(Name_i, ''))), 30) firstName
    ,left(ltrim(rtrim(coalesce(Name_o, ''))), 30) middleName
    ,left(ltrim(rtrim(coalesce(Full_Name, ''))), 512) fullFIO
    ,left(ltrim(rtrim(coalesce(Name_old, ''))), 30) lastNameOld
    ,left(ltrim(rtrim(coalesce(Name_i_old, ''))), 30) firstNameOld
    ,left(ltrim(rtrim(coalesce(Name_o_old, ''))), 30) middleNameOld
from Card c1
where c1.Name_old is not null 
and c1.Auto_Card in (
	select distinct p1.Auto_Card
	from people p1
	where (@orgID is null or @orgID = p1.id_Firm)
	    and people.out_date = '1900-01-01'
        and people.sovm <> 2
)
