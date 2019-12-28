'use strict'

const fs = require('fs')
const Source = require('../Source')
const Target = require('../Target')
const makeFile = require('./IsproTarget')
const sql = require('mssql')

const SQL_FILES_DIR = './assets/ispro/'

class IsproSource extends Source {
    constructor() {
        super()
    }

    async read(config, sendFile) {
            let pool = new sql.ConnectionPool(dbConfig(config))
            pool.on('error', (err) => {
                throw err
            })
            await pool.connect()
            let fileList = await getFileList()
            let taskList = makeTaskList(config, pool, fileList, sendFile)
            await Promise.all(taskList)
            pool.close()
    }
}

function getFileList() {
    return new Promise((resolve, reject) => {
        fs.readdir(SQL_FILES_DIR, (err, fileList) => {
            if (err) reject(err);
            resolve(fileList)
        })
    })
}

function makeTaskList(config, pool, fileList, sendFile) {
    return fileList.map((fileName) => {
        return new Promise(async (resolve) => {
            let target = new Target.Target()
            target.fileName = Target.getTargetFileName(config, fileName)
            target.queryFileName = SQL_FILES_DIR + fileName
            target.config = config
            target.pool = pool
            target = await makeFile(target)
            sendFile(target)
            resolve(true)
        })
    })
}

function dbConfig(config) {
    return {
        user: config.login,
        password: config.password,
        server: config.server,
        database: config.schema,
    }
}

module.exports = IsproSource
