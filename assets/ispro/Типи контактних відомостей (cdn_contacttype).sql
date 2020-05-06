-- Типи контактних відомостей (cdn_contacttype)
/*BEGIN-OF-HEAD*/
select 'ID' ID, 'code' code, 'name' name
union all
/*END-OF-HEAD*/
select '1' ID, 'email' code, 'Електронна адреса' name
union all
select '2' ID, 'legalAddr' code, 'Адреса реєстрації' name
union all
select '3' ID, 'actualAddr' code, 'Адреса фактичного проживання' name
union all
select '4' ID, 'phone' code, 'Телефон' name
union all
select '5' ID, 'mobPhone' code, 'Мобільний телефон' name
union all
select '6' ID, 'filName' code, 'Номер філії' name
union all
select '7' ID, 'postAddr' code, 'Поштова адреса' name
union all
select '8' ID, 'fax' code, 'Факс' name
union all
select '9' ID, 'other' code, 'Інший' name
