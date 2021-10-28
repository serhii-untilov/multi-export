'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const Target = require('../Target')
const iconv = require('iconv-lite')
const QueryStream = require('pg-query-stream')
const JSONStream = require('JSONStream')

const queryText = `
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
`

const makeFile = function (target) {
    return new Promise((resolve, reject) => {
        target.state = Target.FILE_EMPTY
        target.client.query(queryText, (err, res) => {
            if (err) {
                target.state = Target.FILE_ERROR
                target.err = err.message
                reject(target)
            } else {
                resolve(target)
            }
        })
    })
}

module.exports = makeFile
