declare @orgID bigint = (case when ''/*OKPO*/ = '' then null else coalesce((select ID from HR_FIRM where OKPO = ''/*OKPO*/), -1) end)
select 
	Struct_Code ID
	,Struct_Code code
	,coalesce(short_name, Struct_Name) name
	,coalesce(Struct_Name, short_name) fullName
	,id_Firm orgID
	,Struct_Parent parentUnitID
	,state = 'ACTIVE'
	,cast(cast(s1.date_in as date) as varchar) dateFrom
	,cast(cast((case when s1.date_out in ('1900-01-01', '2099-01-01') then '9999-12-31' else s1.date_out end) as date) as varchar) dateTo
	,ord_num idxNum
	,(cast(Struct_Code as varchar) + ' ' + coalesce(short_name, Struct_Name)) description
	,(coalesce(short_name, Struct_Name) + ' [' + cast(Struct_Code as varchar) + ']') caption
	,coalesce(short_name, Struct_Name) nameNom
	,coalesce(struct_name_R, '') nameGen
	,coalesce(struct_name_V, '') nameAcc
	,coalesce(struct_name_D, '') nameDat	
	,coalesce(struct_name_T, '') nameOr
	,coalesce(struct_name_P, '') nameVoc
	,coalesce(short_name, Struct_Name) fullNameNom
	,coalesce(struct_name_R, '') fullNameGen
	,coalesce(struct_name_V, '') fullNameAcc
	,coalesce(struct_name_D, '') fullNameDat	
	,coalesce(struct_name_T, '') fullNameOr
	,coalesce(struct_name_P, '') fullNameVoc
from StructS s1
where (@orgID is null or @orgID = id_Firm)
	and (Flag_deleted = 0 or Struct_Code in (
		select distinct p1.Code_struct_name
		from PR_CURRENT p1
		inner join Card c1 on c1.Auto_Card = p1.Auto_Card
		inner join people n1 on n1.Auto_Card = p1.Auto_Card and p1.Date_trans between n1.in_date and n1.out_date
		where (@orgID is null or @orgID = p1.id_Firm)
	))
order by Struct_Code