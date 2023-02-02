'use strict'

const fs = require('fs')
const path = require('path')
const sql = require('mssql')
const Source = require('../Source')
const Target = require('../Target')
const makeDir = require('../helper/makeDir')
const makeFile = require('./TargetBossk')
const getFullFileName = require('../helper/getFullFileName')
const makeArchive = require('../helper/makeArchive')
const removeTargetFiles = require('../helper/removeTargetFiles')

const SQL_FILES_DIR = './assets/bossk/'

const POOL_SIZE = 4
const CONNECTION_TIMEOUT = 20 * 60 * 1000 // 20 minutes
const REQUEST_TIMEOUT = 20 * 60 * 1000 // 20 minutes
const ACQUIRE_TIMEOUT = 20 * 60 * 1000 // 20 minutes

class SourceBossk extends Source {
    async read (config, sendFile, sendDone, sendFailed) {
        const pool = new sql.ConnectionPool(dbConfig(config))
        pool.on('error', (err) => {
            console.log(err)
            sendFailed(err.message)
        })

        pool.connect()
            .then(() => makeDir(config.targetPath))
            .then(() => getFileList())
            .then((fileList) => {
                return Promise.all(
                    fileList.map((queryFileName) => {
                        return new Promise((resolve, reject) => {
                            const target = new Target.Target()
                            const fileName = path.parse(queryFileName).name
                            target.fullFileName = getFullFileName(config.targetPath, fileName + '.csv')
                            target.queryFileName = getFullFileName(SQL_FILES_DIR, queryFileName)
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
                    let arcFileName
                    getFirmName(pool, config.orgCode)
                        .then((firmName) => getFullFileName(config.targetPath, firmName + config.orgCode + '.zip'))
                        .then((fullFileName) => { arcFileName = fullFileName })
                        .then(() => makeArchive(arcFileName, targetList))
                        .then(() => removeTargetFiles(targetList))
                        .then(() => sendDone(arcFileName))
                        .catch((err) => sendFailed(err.message))
                } else {
                    sendDone(null)
                }
            })
            .catch(err => {
                sendFailed(err.message)
            })

    }
}

function getFirmName (pool, orgCode = '') {
    const defaultName = 'БОСС-Кадровик'
    if (orgCode.length) {
        return new Promise((resolve, reject) => {
            pool.request()
                .query(`select coalesce(SNAME, NAME) name from HR_FIRM where OKPO = ${orgCode}`)
                .then(result => {
                    let name = result && result.recordset.length ? result.recordset[0].name : defaultName
                    name = name.replace(/"/g, '_').replace(/'/g, '_').replace(/\./g, '_')
                        .replace(/,/g, '_').replace(/ /g, '_').replace(/__/g, '_')
                    resolve(name.length ? name : defaultName)
                })
                .catch(err => reject(err))
            const currentDate = new Date()
            resolve(currentDate.toString())
        })
    } else {
        return new Promise((resolve, reject) => {
            resolve(defaultName)
        })
    }
}

function getFileList () {
    return new Promise((resolve, reject) => {
        fs.readdir(SQL_FILES_DIR, { withFileTypes: true }, (err, dirents) => {
            if (err) reject(err)
            const fileList = dirents
                .filter((el) => { return !el.isDirectory() && path.extname(el.name).toLowerCase() === '.sql' })
                .map((el) => { return el.name })
            resolve(fileList)
        })
    })
}

function dbConfig (config) {
    const isNamedInstance = (config.server.indexOf('\\') >= 0)
    const params =  {
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
    if (isNamedInstance) {
        params.domain = config.domain
    }
    if (!isNamedInstance && config.port.length) {
        // Don't set when connecting to named instance
        params.port = Number(config.port)
    }
    return params
}

module.exports = SourceBossk
