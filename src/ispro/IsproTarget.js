'use strict'

const sql = require('mssql')
const fs = require('fs')
const Target = require('../Target')

class IsproTarget extends Target.Target {
    constructor(fileName) {
        super(fileName)
    }

    getConnectionString(config) {
        return `mssql://${config.login}:${config.password}@${config.server}/${config.schema}`
    }

    async doQuery(connectionString, queryText) {
        try {
            await sql.connect(connectionString)
            let result = await sql.query(queryText)
            return result.recordset
        } catch (err) {
            return err
        }
    }

    makeFile(config, queryText) {
        let connectionString = this.getConnectionString(config)
        let recordset = this.doQuery(connectionString, queryText)

        if (recordset.length == 0) {
            this.state = Target.FILE_EMPTY
            return
        }

        let buffer = ''
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

        this.targetFile = this.getTargetFileName(config)
        fs.writeFile(this.targetFile, buffer, (err) => {
            console.log(err)
            this.state = Target.FILE_ERROR
            this.err = err
            throw err
        })

        this.state = Target.FILE_CREATED
    }
}

module.exports = IsproTarget
