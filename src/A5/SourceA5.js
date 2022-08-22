'use strict'

const { Pool } = require('pg')
const Source = require('../Source')
const Target = require('../Target')
const makeDir = require('../helper/makeDir')
const makeFile = require('./TargetA5')
const getFullFileName = require('../helper/getFullFileName')
const makeArchive = require('../helper/makeArchive')
const removeTargetFiles = require('../helper/removeTargetFiles')

const FILE_NAME = 'A5.zip'

const POOL_SIZE = 4
const CONNECTION_TIMEOUT = 20 * 60 * 1000 // 20 minutes
const REQUEST_TIMEOUT = 20 * 60 * 1000 // 20 minutes

const tableList = [
    'ac_address',
    'ac_dictDocKind',
    'ac_dictProgClass',
    'ac_fundSource',
    'cdn_country',
    'hr_payEl',
    'hr_accrual',
    'hr_department',
    'hr_dictBenefitsKind',
    'hr_dictCategoryECB',
    'hr_dictEducationLevel',
    'hr_dictExperience',
    'hr_dictPosition',
    'hr_dictStaffCat',
    'hr_dictTarifCoeff',
    'hr_employee',
    'hr_employeeAccrual',
    'hr_employeeBenefits',
    'hr_employeeDocs',
    'hr_employeeEducation',
    'hr_employeeExperience',
    'hr_employeeNumber',
    'hr_employeePosition',
    'hr_employeeTaxLimit',
    'hr_organization',
    'hr_payOut',
    'hr_payRetention',
    'hr_taxLimit',
    'hr_workSchedule'
]

class SourceA5 extends Source {
    async read (config, sendFile, sendDone, sendFailed) {
        const pool = new Pool(dbConfig(config))
        pool.on('error', (err) => {
            console.log(err)
            sendFailed(err.message)
        })
        makeDir(config.targetPath)
            .then(() => {
                return Promise.all(
                    tableList.map((tableName) => {
                        return new Promise((resolve, reject) => {
                            pool.connect()
                                .then(client => {
                                    const target = new Target.Target()
                                    target.tableName = tableName
                                    target.fullFileName = getFullFileName(config.targetPath, tableName + '.csv')
                                    target.config = config
                                    target.client = client
                                    return target
                                })
                                .then(target => makeFile(target))
                                .then(target => {
                                    sendFile(target)
                                    target.client.release(true)
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
                    getFullFileName(config.targetPath, FILE_NAME)
                        .then(fullFileName => { arcFileName = fullFileName })
                        .then(() => makeArchive(arcFileName, targetList))
                        .then(() => removeTargetFiles(targetList))
                        .then(() => sendDone(arcFileName))
                        .catch(err => {
                            sendFailed(err.message)
                        })
                } else {
                    sendDone(null)
                }
            })
            .catch(err => {
                sendFailed(err.message)
            })
    }
}

function dbConfig (config) {
    return {
        host: config.a5Host,
        port: config.a5Port,
        user: config.a5Login,
        password: config.a5Password,
        database: config.a5Database,
        connectionTimeoutMillis: CONNECTION_TIMEOUT,
        idleTimeoutMillis: REQUEST_TIMEOUT,
        max: POOL_SIZE
    }
}

module.exports = SourceA5
