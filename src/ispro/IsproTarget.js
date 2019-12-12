'use strict'

const sql = require('mssql')
const fs = require('fs')
const Target = require('../Target')

// async function makeFile(config, fileName) {
//     let target = new IsproTarget(fileName)
//     try {
//         let queryText = await readQueryFromFile(fileName)
//         target.makeFile(config, queryText)
//         return target
//     } catch (err) {
//         target.err = err
//         target.state = Target.FILE_ERROR
//         return target
//     }
// }

function readQueryFromFile(fileName) {
    return new Promise((resolve, reject) => {
        fs.readFile(fileName, 'utf8', (err, queryText) => {
            if (err) reject(err);
            resolve(queryText)
        })
    })
}

function getConnectionString(config) {
    return `mssql://${this.config.login}:${this.config.password}@${this.config.server}/${this.config.schema}`
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
    let buffer = JSON.stringify(recordset)
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

class IsproTarget extends Target.Target {
    constructor(config, fileName) {
        super(fileName)
        this.config = config
    }
    
    async makeFile(config, queryText) {
        try {
            const connectionString = getConnectionString(this.config)
            this.targetFile = getTargetFileName(this.config)
            const queryText = await readQueryFromFile(this.targetFile)
            const recordset = await doQuery(connectionString, queryText)

            if (recordset.length == 0) {
                this.state = Target.FILE_EMPTY
                return
            }

            await writeFile(this.targetFile, recordset)
            this.state = Target.FILE_CREATED

        } catch (err) {
            this.state = Target.FILE_ERROR
            this.err = err
        }
    }
}

module.exports = IsproTarget
