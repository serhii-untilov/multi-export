MultiExport
============
The MultiExport application exports data from accounting systems databases and prepares files for importing into the 'A5 Systems' database.

Preview
-------
![Preview](./assets/images/preview.png)

Download
--------
<a href="https://drive.google.com/open?id=11c8HZv5hzv3u0xsF8NN3OAd92KyPLYqf"
    download
    target="_blank"
    >Download Multi-Export.exe
    </a>

Afrer clone from repository
---------------------------
```
yarn
yarn test
yarn start
```

To make executable file
-----------------------
```
yarn
yarn run dist
```
Then you can find the executable file in the .\dist subdirectory.

Environment variables
---------------------
[The Medium article how to use environment variables](https://medium.com/the-node-js-collection/making-your-node-js-work-everywhere-with-environment-variables-2da8cdf6e786)

Create .env file, put into it the next content and fill fields
```
NODE_ENV=development

# Set your database connection information here
SERVER=
LOGIN=
PASSWORD=
SCHEMA=
SCHEMASYS=

```

Notes about the SQL Server configuration to make connection
------------------------------------------------------------
[Configure a Windows Firewall for Database Engine Access](https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/configure-a-windows-firewall-for-database-engine-access?view=sql-server-ver15)

Configure SQL Server access protocols:
* Run SQL Server Configuration Manager
* Find SQL Server Network Configuration\Protocol for [Your Server Name]
* In the right pane turn on Status Enabled for TCP/IP and Shared Memory protocols
* Then make double click on the TCP/IP protocol and in the opened dialog box find the IPAll section:
    * Write 0 in TCP Dynamic ports
    * Write 1433 in TCP Port

PostgreSQL convert UUID into bigint
-----------------------------------
```
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
```
-- Test
select base.uuid_bigint(id::text), * from base.department;
```