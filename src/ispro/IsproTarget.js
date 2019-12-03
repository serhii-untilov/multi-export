'use strict'

const sql = require('mssql')
const Target = require('../Target')

class IsproTarget extends Target.Target {
    constructor(fileName) {
        super(fileName)
    }

    makeConnectionString(config) {
        return `mssql://${config.login}:${config.password}@${config.server}/${config.schema}`
    }

    async makeFile(content, config) {
        try {
            let connectionString = this.makeConnectionString(config)
            await sql.connect(connectionString)
            let result = await sql.query(content)
            let recordset = result.recordsets[0]
            buffer = ''
            for (let record = 0; record < recordset.length; record++) {
                let fieldset = recordset[record].output
                for (let field = 0; field < fieldset.length; field++) {
                    console.log(fieldset[field][1])
                    if (field)
                        buffer += ';'
                    buffer += fieldset[field][1]
                }
                buffer += '\n\r'
            }
            this.targetFile = makeFileName(config)
            fs.writeFile(this.targetFile, buffer)
            this.state = Target.FILE_CREATED
        }
        catch (err) {
            console.log(this.fileName, err)
            this.state = Target.FILE_ERROR
            this.err = err
        }
    }
}

module.exports = IsproTarget
