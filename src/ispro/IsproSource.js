'use strict'

const fs = require('fs')
const Source = require('../Source')
const Target = require('../Target')
const makeFile = require('./IsproTarget')
const sql = require('mssql')
const ArchiveMaker = require('../ArchiveMaker')

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
        let targetList = []
        let targetPromiseList = makeTargetPromiseList(config, pool, fileList, async (target) => {
            sendFile(target)
            targetList.push(target)
            if (targetList.length == targetPromiseList.length) {
                if (config.isArchive) {
                    let archiveName = await this.getFirmName(pool)
                    let arc = new ArchiveMaker(config, archiveName)
                    arc.make(targetList, () => {
                        removeFiles(targetList)
                        sendDone()
                    })
                } else {
                    sendDone()
                }
            }
        })
        await Promise.all(targetPromiseList)
    }

    async getFirmName(pool) {
        try {
            const request = pool.request();
            const result = await request.query('select CrtFrm_Nm from CrtFrm1')
            return result.recordset[0]['CrtFrm_Nm'];
        } catch (err) {
            console.log('getFirmName', err)
            return null
        }
    }
}

function removeFiles(targetList) {
    for (let i = 0; i < targetList.length; i++) {
        if (targetList[i].state == Target.FILE_CREATED) {
            let fileName = targetList[i].fileName
            fs.exists(fileName, (exists) => {
                if (exists) {
                    fs.unlink(fileName, (err) => { })
                }
            })
        }
    }
}

function makeTargetPromiseList(config, pool, fileList, sendFile) {
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
                console.log('makeTargetPromiseList', err)
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
