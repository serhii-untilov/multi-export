'use strict'

const fs = require('fs')
const path = require('path')
const sql = require('mssql')
const Source = require('../Source')
const Target = require('../Target')
const makeFile = require('./IsproTarget')
const fullFileName = require('../helper/fullFileName')
const makeArchive = require('../helper/makeArchive')
const removeTargetFiles = require('../helper/removeTargetFiles')

const SQL_FILES_DIR = './assets/ispro/'

const POOL_SIZE = 4
const CONNECTION_TIMEOUT = 20 * 60 * 1000 // 20 minutes
const REQUEST_TIMEOUT = 20 * 60 * 1000 // 20 minutes
const ACQUIRE_TIMEOUT = 20 * 60 * 1000 // 20 minutes

class IsproSource extends Source {
    constructor() {
        super()
    }

    async read(config, sendFile, sendDone, sendFailed) {
        let pool = new sql.ConnectionPool(dbConfig(config))
        pool.on('error', (err) => {
            console.log(err)
            sendFailed(err.message)
        })
        pool.connect()
        .then(() => getFileList())
        .then((fileList) => {
            return Promise.all(
                fileList.map((queryFileName) => {
                    return new Promise(async (resolve, reject) => {
                        let target = new Target.Target()
                        let fileName = path.parse(queryFileName).name
                        target.fileName = fullFileName(config.targetPath, fileName + '.csv')
                        target.queryFileName = fullFileName(SQL_FILES_DIR, queryFileName)
                        target.config = config
                        target.pool = pool
                        makeFile(target)
                        .then(target => {
                            sendFile(target)
                            resolve(target)
                        })
                        .catch(err => reject(err))
                    })
                })
            )
        })
        .then((targetList) => {
            if (config.isArchive) {
                getFirmName(pool)
                .then((firmName) => fullFileName(config.targetPath, firmName + '.zip'))
                .then((arcFileName) => makeArchive(arcFileName, targetList))
                .then(() => removeTargetFiles(targetList))
                .then(() => sendDone(null))
                .catch((err) => sendFailed(err.message))
            } else {
                sendDone(null)
            }
        })
        .catch((err) => sendFailed(err.message))
    }
}

function getFirmName(pool) {
    return new Promise((resolve, reject) => {
        pool.request()
        .query('select CrtFrm_Nm from CrtFrm1')
        .then(result => {
            let firmName = result.recordset[0]['CrtFrm_Nm']
            firmName = firmName.replace(/\"/g, '_').replace(/\'/g, '_').replace(/\./g, '_')
                .replace(/\,/g, '_').replace(/ /g, '_').replace(/__/g, '_')
            resolve(firmName)
        })
        .catch(err => reject(err))
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
        connectionTimeout: CONNECTION_TIMEOUT,
        requestTimeout: REQUEST_TIMEOUT,
        pool: {
            max: POOL_SIZE,
            min: 0,
            acquireTimeoutMillis: ACQUIRE_TIMEOUT
        }
    }
}

module.exports = IsproSource
