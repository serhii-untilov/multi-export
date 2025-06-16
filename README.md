# MultiExport

The MultiExport application, which prepares files for importing into the "A5 Systems" database.

## Preview

![Preview](./assets/images/preview.png)

## Download

[Download Multi-Export.exe](https://drive.google.com/drive/folders/1UUKxbe4Ku08w6Qs2olWQVxBRxIJOcRia?usp=sharing)

Export from IS-Pro Oracle DB - [Download IsproOracleExport.exe](https://drive.google.com/drive/folders/1YH3mHGaI2lPrdmFOIGmQrSbS6ET-DPpl?usp=sharing)

Export from Kartka-Web Oracle DB - [Download KartkaExport.exe](https://drive.google.com/drive/folders/1RG1sIIPiWTLgNlVmzgqmt-dvI0YppmIb?usp=sharing)

## Afrer clone from repository

``` sh
npm ci
npm start
```

## To make executable file

``` sh
npm ci
npm run dist
```

Then you can find the executable file in the .\dist subdirectory.

## Environment variables

[The Medium article how to use environment variables](https://medium.com/the-node-js-collection/making-your-node-js-work-everywhere-with-environment-variables-2da8cdf6e786)

Create .env file, put into it the next content and fill fields

``` sh
NODE_ENV=development
```

## Set your database connection information here

``` sh
SERVER=
LOGIN=
PASSWORD=
SCHEMA=
SCHEMASYS=
```

## Notes about the SQL Server configuration to make connection

[Configure a Windows Firewall for Database Engine Access](https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/configure-a-windows-firewall-for-database-engine-access?view=sql-server-ver15)

Configure SQL Server access protocols:

- Run SQL Server Configuration Manager
- Find SQL Server Network Configuration\Protocol for [Your Server Name]
- In the right pane turn on Status Enabled for TCP/IP and Shared Memory protocols
- Then make double click on the TCP/IP protocol and in the opened dialog box find the IPAll section:
  - Write 0 in TCP Dynamic ports
  - Write 1433 in TCP Port

## PostgreSQL convert UUID into bigint

``` SQL
-- FUNCTION: base.uuid_bigint(character varying)
-- DROP FUNCTION base.uuid_bigint(character varying);
CREATE OR REPLACE FUNCTION base.uuid_bigint(
 hexval character varying)
RETURNS bigint
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$
declare
 result bigint;
BEGIN
   select substring((select replace(hexval,'-','')) from 1 for 16) into hexval;
   EXECUTE 'SELECT x''' || hexval || '''::bigint' INTO result;
   select abs(result) into result;
   RETURN result;
END;
$BODY$;

ALTER FUNCTION base.uuid_bigint(character varying)
    OWNER TO test;
```

``` SQL
-- Test
select base.uuid_bigint(id::text), * from base.department;
```
