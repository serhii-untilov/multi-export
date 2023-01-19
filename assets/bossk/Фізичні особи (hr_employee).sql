select
    cast(Auto_Card as varchar) ID
    ,Name lastName
    ,Name_i firstName
    ,Name_o middleName
    ,Full_Name fullFIO
    ,case when Sex = 0 then 'M' when Sex = 1 then 'W' else '' end sexType
    ,cast(cast(Date_birth as date) as varchar) birthDate
    -- ,Citizenship citizenshipID -- cdn_country
    ,INN taxCode
    ,EMail email
    ,'NEW' state
from Card
