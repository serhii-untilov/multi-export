'use strict'

const fs = require('fs')
const path = require('path')
const { Pool } = require('pg')
const Source = require('../Source')
const { Target } = require('../Target')
const makeDir = require('../helper/makeDir')
const makeFile = require('./TargetAPK')
const getFullFileName = require('../helper/getFullFileName')
const makeArchive = require('../helper/makeArchive')
const removeTargetFiles = require('../helper/removeTargetFiles')
const initDB = require('./initDB')
const dictDocKind = require('./hr_dictDocKind')

const SQL_FILES_DIR = './assets/APK/'
const FILE_NAME = 'AПК.zip'

const POOL_SIZE = 4
const CONNECTION_TIMEOUT = 20 * 60 * 1000 // 20 minutes
const REQUEST_TIMEOUT = 20 * 60 * 1000 // 20 minutes

class SourceAPK extends Source {
    async read(config, sendFile, sendDone, sendFailed) {
        const pool = new Pool(dbConfig(config))
        pool.on('error', (err) => {
            console.log(err)
            sendFailed(err.message)
        })
        let fileList
        let client
        makeDir(config.targetPath)
            .then(() => getFileList())
            .then((result) => {
                fileList = result
            })
            .then(() => pool.connect())
            .then((result) => {
                client = result
            })
            .then(() => {
                const target = new Target()
                target.config = config
                target.client = client
                return initDB(target)
            })
            .then(() => {
                return dictDocKind(config)
            })
            .then(() => {
                return Promise.all(
                    fileList.map((queryFileName) => {
                        return new Promise((resolve, reject) => {
                            const target = new Target()
                            const fileName = path.parse(queryFileName).name
                            target.fullFileName = getFullFileName(
                                config.targetPath,
                                fileName + '.csv'
                            )
                            target.queryFileName = getFullFileName(SQL_FILES_DIR, queryFileName)
                            target.config = config
                            target.client = client
                            makeFile(target)
                                .then((target) => {
                                    sendFile(target)
                                    resolve(target)
                                })
                                .catch((err) => reject(err))
                        })
                    })
                )
            })
            .then((targetList) => {
                if (config.isArchive) {
                    const arcFileName = getFullFileName(config.targetPath, FILE_NAME)
                    makeArchive(arcFileName, targetList)
                        .then(() => removeTargetFiles(targetList))
                        .then(() => sendDone(arcFileName))
                        .catch((err) => sendFailed(err.message))
                } else {
                    sendDone(null)
                }
            })
            .catch((err) => sendFailed(err.message))
    }
}

function getFileList() {
    return new Promise((resolve, reject) => {
        fs.readdir(SQL_FILES_DIR, { withFileTypes: true }, (err, dirents) => {
            if (err) reject(err)
            const fileList = dirents
                .filter((el) => {
                    return !el.isDirectory() && path.extname(el.name).toLowerCase() === '.sql'
                })
                .map((el) => {
                    return el.name
                })
            resolve(fileList)
        })
    })
}

function dbConfig(config) {
    return {
        host: config.apkHost,
        port: config.apkPort,
        user: config.apkLogin,
        password: config.apkPassword,
        database: config.apkDatabase,
        connectionTimeoutMillis: CONNECTION_TIMEOUT,
        idleTimeoutMillis: REQUEST_TIMEOUT,
        max: POOL_SIZE
    }
}

module.exports = SourceAPK
