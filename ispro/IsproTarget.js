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
            let connectionString = makeConnectionString(config)
            await sql.connect(connectionString)
            const result = await sql.query(content)
            console.dir(result)

            this.state = Target.FILE_CREATED
        }
        catch (err) {
            console.log(fileName, err)
            this.state = Target.FILE_ERROR
            this.err = err
        }
    }
}

module.exports = IsproTarget
