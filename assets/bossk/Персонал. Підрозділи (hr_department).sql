declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ЄДРПОУ', '' - усі організації
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)
select Struct_Code as ID,
    id_Firm as impOrgID,
    case when Struct_Parent=(select max(Struct_Code) from StructS where StructS.Struct_Lev = 0 and id_Firm=@orgID)  then null else Struct_Parent end as parentUnitID,
    Struct_Code as code,
    Struct_Name as name,
    Struct_Name as fullName,
    sort as idxNum,
    struct_name_r as nameGen,
    struct_name_d as nameDat,
    struct_name_v as nameAcc,
    struct_name_t as nameOr,
    struct_name_p as nameLoc,
    struct_name_r as fullNameGen,
    struct_name_d as fullNameDat,
    struct_name_v as fullNameAcc,
    struct_name_t as fullNameOr,
    struct_name_p as fullNameLoc
from StructS
where Flag_deleted = 0
and Struct_Parent <> 0
and (@orgID is null or @orgID = id_Firm)
