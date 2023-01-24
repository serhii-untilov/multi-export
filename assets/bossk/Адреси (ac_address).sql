declare @orgID bigint = (case when /*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = /*OKPO*/), -1) end)
select * 
from (
	SELECT 
		10000 + card.Auto_Card as ID,
		card.Auto_Card as ownerID,
		1 as countryID ,
		1 as addressType ,
		Card.rAddr_Zip as postIndex,
		ltrim(rtrim(
			Card.rAddr_Region+ case when ltrim(Card.rAddr_Region)='' then '' else ' область, ' end +
			Card.rAddr_okrug+case when  ltrim(Card.rAddr_okrug)='' then '' else ' р-н, ' end +
			Card.rAddr_City +
			case when rtrim(Card.rAddr_Street) = '' then '' else ', ' end+rtrim(Card.rAddr_Street) +
			case when ltrim(Card.rAddr_House) = '' then '' else ', ' end + rtrim(Card.rAddr_House) +
			case when  ltrim(Card.rAddr_Block) = '' then '' else '-' end + rtrim(Card.rAddr_Block) +
			case when  ltrim(Card.rAddr_Flat) = '' then '' else ', кв. ' end + rtrim(Card.rAddr_Flat) 
		))  address
	from card 
	inner join people  ON people.Auto_Card = card.Auto_Card 
	where people.out_date = '1900-01-01'
		and people.sovm <> 2 
		and (@orgID is null or @orgID = people.id_Firm)

	UNION
	
	SELECT
		card.Auto_Card as ID,
		card.Auto_Card as ownerID,
		1 as countryID ,
		2 as addressType ,
		Card.Addr_Zip as postIndex,
		ltrim(rtrim(
			Card.Addr_Region + case when ltrim(Card.Addr_Region) = '' then '' else ' область, ' end +
			Card.Addr_okrug + case when  ltrim(Card.Addr_okrug) = '' then '' else ' р-н, ' end +
			Card.Addr_City +
			case when rtrim(Card.Addr_Street) = '' then '' else ', ' end+rtrim(Card.Addr_Street) +
			case when ltrim(Card.Addr_House) = '' then '' else ', ' end + rtrim(Card.Addr_House) +
			case when  ltrim(Card.Addr_Block) = '' then '' else '-' end + rtrim(Card.Addr_Block) +
			case when  ltrim(Card.Addr_Flat) = '' then '' else ', кв. ' end + rtrim(Card.Addr_Flat) 
		)) as address
	from card 
	inner join people ON people.Auto_Card = card.Auto_Card 
	where people.out_date = '1900-01-01'
		and people.sovm <> 2
		and (@orgID is null or @orgID = people.id_Firm)
) t1
where address is not null and address <> ''
order by ownerID, addressType