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

    async read(config, sendFile, sendDone) {
        let pool = new sql.ConnectionPool(dbConfig(config))
        pool.on('error', (err) => {
            throw err
        })
        await pool.connect()
        let fileList = await getFileList()
        let targetsDone = 0
        let targetList = makeTargetList(config, pool, fileList, (target) => {
            sendFile(target)
            targetsDone++
            if (targetsDone == targetList.length) {
                sendDone()
                // pool.close()
            }
        })
        await Promise.all(targetList)
    }
}

function makeTargetList(config, pool, fileList, sendFile) {
    return fileList.map((fileName) => {
        return new Promise(async (resolve, reject) => {
            try {
                let target = new Target.Target()
                target.fileName = Target.getTargetFileName(config, fileName)
                target.queryFileName = SQL_FILES_DIR + fileName
                target.config = config
                target.pool = pool
                target.done = sendFile
                target = await makeFile(target)
                resolve(true)
            } catch (err) {
                reject(err)
            }
        })
    })
}

function getFileList() {
    return new Promise((resolve, reject) => {
        fs.readdir(SQL_FILES_DIR, (err, fileList) => {
            if (err) reject(err);
            resolve(fileList)
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
