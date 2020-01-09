'use strict'

const fs = require('fs')
const Source = require('../Source')
const Target = require('../Target')
const makeFile = require('./IsproTarget')
const sql = require('mssql')
const ArchiveMaker = require('../ArchiveMaker')
const path = require('path')
// const { mainWindow } = require('../../main')

const SQL_FILES_DIR = './assets/ispro/'

class IsproSource extends Source {
    constructor() {
        super()
    }

    async read(config, sendFile, sendDone, sendFailed) {
        try {
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
                //mainWindow.setProgressBar(targetPromiseList.length / 100 * targetList.length)
                if (targetList.length == targetPromiseList.length) {
                    if (config.isArchive) {
                        let firmName = await this.getFirmName(pool)
                        let arc = new ArchiveMaker(config, firmName)
                        arc.make(targetList, (arcFileName) => {
                            removeFiles(targetList)
                            sendDone(arcFileName)
                        })
                    } else {
                        sendDone()
                    }
                }
            })
            await Promise.all(targetPromiseList)
        } catch (err) {
            sendFailed(err.message)
        }
    }

    async getFirmName(pool) {
        try {
            const request = pool.request();
            const result = await request.query('select CrtFrm_Nm from CrtFrm1')
            let firmName = result.recordset[0]['CrtFrm_Nm']
            firmName = firmName.replace(/\"/g, '_').replace(/\'/g, '_').replace(/\./g, '_')
                .replace(/\,/g, '_').replace(/ /g, '_').replace(/__/g, '_')
            return firmName;
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
        fs.readdir(SQL_FILES_DIR, { withFileTypes: true }, (err, dirents) => {
            if (err) reject(err);
            let fileList = dirents
                .filter((el) => {return !el.isDirectory() && path.extname(el.name).toLowerCase() == '.sql'})
                .map((el) => {return el.name})
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
        connectionTimeout: 300000,
        requestTimeout: 600000,
        pool: {
            max: 1,
            min: 0,
            idleTimeoutMillis: 300000
        }
    }
}

module.exports = IsproSource
