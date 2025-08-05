-- Типи контактних відомостей (cdn_contacttype)
select '1' "ID", 'email' "code", 'Електронна адреса' "name" FROM dual
union all
select '2' "ID", 'legalAddr' "code", 'Адреса реєстрації' "name" FROM dual
union all
select '3' "ID", 'actualAddr' "code", 'Адреса фактичного проживання' "name" FROM dual
union all
select '4' "ID", 'phone' "code", 'Телефон' "name" FROM dual
union all
select '5' "ID", 'mobPhone' "code", 'Мобільний телефон' "name" FROM dual
union all
select '6' "ID", 'filName' "code", 'Номер філії' "name" FROM dual
union all
select '7' "ID", 'postAddr' "code", 'Поштова адреса' "name" FROM dual
union all
select '8' "ID", 'fax' "code", 'Факс' "name" FROM dual
union all
select '9' "ID", 'other' "code", 'Інший' "name" FROM dual
