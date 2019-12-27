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

// function getConnectionString(config) {
//     try {
//         return `mssql://${config.login}:${config.password}@${config.server}/${config.schema}`
//     } catch (err) {
//         console.log(err)
//         throw(err)
//     }
// }

// async function doQuery(connectionString, queryText) {
//     try {
//         await sql.connect(connectionString)
//         let result = await sql.query(queryText)
//         return result.recordset
//     } catch (err) {
//         return err
//     }
// }

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
    // let buffer = JSON.stringify(recordset)
    let buffer = ''

    console.log(filename, recordset)
    for (let record in recordset) {
        //console.log(fileName, record)
        for (let field in recordset[record]) {
            // console.log(record[field])
            buffer += record[field]
            buffer += ';'
        }
        buffer += '\n\r'
    }

    fs.writeFile(fileName, buffer, (err) => {
        if (err) throw err;
    })
}

async function makeFile(target) {
    try {
        const queryText = await readQueryFromFile(target.queryFileName)
        const recordset = await doQuery(target.pool, queryText)
        if (recordset.length == 0) {
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
