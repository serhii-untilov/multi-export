-- Підрозділи (hr_department)
declare @sysste_rcd bigint = (select max(sysste_rcd) from sysste where sysste_cd = /*SYSSTE_CD*/)
select
	cast(sprpdr_rcd as varchar) ID,
	REPLACE(REPLACE(SprPdr_Pd, CHAR(13), ''), CHAR(10), '') code,
	REPLACE(REPLACE(sprpdr_nm, CHAR(13), ''), CHAR(10), '') name,
	cast(sprpdr_prcd as varchar) parentUnitID,
	state = 'ACTIVE',
	REPLACE(REPLACE(SprPdr_NmFull, CHAR(13), ''), CHAR(10), '') fullName,
	REPLACE(REPLACE(SprPdr_NmFull, CHAR(13), ''), CHAR(10), '') description,
	left(REPLACE(REPLACE(sprpdr_nm, CHAR(13), ''), CHAR(10), ''), 128) nameGen,
	REPLACE(REPLACE(SprPdr_NmFull, CHAR(13), ''), CHAR(10), '') fullNameGen,
	left(REPLACE(REPLACE(sprpdr_datPd, CHAR(13), ''), CHAR(10), ''), 128) nameDat,
	left(REPLACE(REPLACE(sprpdr_rodPd, CHAR(13), ''), CHAR(10), ''), 128) nameOr,
	REPLACE(REPLACE(SprPdr_NmFull, CHAR(13), ''), CHAR(10), '') fullNameGen,
	REPLACE(REPLACE(sprpdr_datPd, CHAR(13), ''), CHAR(10), '') fullNameDat
from sprpdr
where SprPdr_Rcd <> 0
	and
	(	sprpdr_flg = 0
		or exists (
			select null
			from kpuprk1
			where kpuprkz_pdrcd = sprpdr_rcd
		)
	)
	and (@sysste_rcd is null or SprPdr_SteRcd = @sysste_rcd)