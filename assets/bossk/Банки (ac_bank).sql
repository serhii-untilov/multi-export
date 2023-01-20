declare @orgID bigint = (case when /*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = /*OKPO*/), -1) end)
select 
	ID
	,MFO
	,MFO code
	,OKPO
	,Name name
	,Name fullName
	,Phone phones
	,(MFO + ' ' + Name) description
from Bnk_Banks
where id in (
	select distinct N_bank
	from const_uder n1
	inner join people p1 on p1.pID = n1.pID
	inner join Card c1 on c1.Auto_Card = p1.Auto_Card
	where (@orgID is null or @orgID = p1.id_Firm)
)