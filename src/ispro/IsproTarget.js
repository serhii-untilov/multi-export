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

function getConnectionString(config) {
    try {
        return `mssql://${config.login}:${config.password}@${config.server}/${config.schema}`
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function doQuery(connectionString, queryText) {
    try {
        await sql.connect(connectionString)
        let result = await sql.query(queryText)
        return result.recordset
    } catch (err) {
        return err
    }
}

async function writeFile(fileName, recordset) {
    
    console.log(fileName, recordset)

    let buffer = JSON.stringify(recordset)
    
    // let buffer = ''
    // for (let record = 0; record < recordset.length; record++) {
    //     let fieldset = recordset[record].output
    //     for (let field = 0; field < fieldset.length; field++) {
    //         console.log(fieldset[field][1])
    //         if (field)
    //             buffer += ';'
    //         buffer += fieldset[field][1]
    //     }
    //     buffer += '\n\r'
    // }

    fs.writeFile(fileName, buffer, (err) => {
        if (err) throw err;
    })
}

async function makeFile(target) {
    try {
        const connectionString = getConnectionString(target.config)
        const queryText = await readQueryFromFile(target.queryFileName)
        const recordset = await doQuery(connectionString, queryText)

        if (recordset.length == 0) {
            target.state = Target.FILE_EMPTY
            return target
        }
        await writeFile(target.fileName, recordset)
        target.state = Target.FILE_CREATED
        console.log(target.fileName, target.state, target.err)
        return target

    } catch (err) {
        target.state = Target.FILE_ERROR
        target.err = err
        return target
    }
}

module.exports = makeFile
