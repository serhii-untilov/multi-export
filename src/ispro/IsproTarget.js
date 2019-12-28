'use strict'

const sql = require('mssql')
const fs = require('fs')
const Target = require('../Target')

function readQueryFromFile(fileName) {
    return new Promise((resolve, reject) => {
        fs.readFile(fileName, 'utf8', (err, queryText) => {
            if (err) reject(err);
            resolve(queryText)
        })
    })
}

async function doQuery(pool, queryText) {
    try {
        const request = pool.request(); // or: new sql.Request(pool1)
        const result = await request.query(queryText)
        return result.recordset
    } catch (err) {
        throw err
    }
}

async function writeFile(fileName, recordset) {
    let buffer = ''
    for (let record in recordset) {
        const fieldset = recordset[record]
        let needSeparator = false
        for (let field in fieldset) {
            if (fieldset.hasOwnProperty(field)) {
                if (needSeparator) buffer += ';'
                needSeparator = true
                buffer += `${fieldset[field]}`
            }
        }
        buffer += '\n'
    }

    fs.writeFile(fileName, buffer, (err) => {
        if (err) throw err;
    })
}

async function makeFile(target) {
    try {
        const queryText = await readQueryFromFile(target.queryFileName)
        const recordset = await doQuery(target.pool, queryText)
        if (recordset.length <= 1) {
            target.state = Target.FILE_EMPTY
            return target
        }
        await writeFile(target.fileName, recordset)
        target.state = Target.FILE_CREATED
        return target
    } catch (err) {
        target.state = Target.FILE_ERROR
        target.err = err
        return target
    }
}

module.exports = makeFile
