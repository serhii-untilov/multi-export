'use strict'

const { Pool } = require('pg')
const sql = require('mssql')
const Source = require('../Source')
const Target = require('../Target')
const makeDir = require('../helper/makeDir')
const makeFile = require('./TargetA5')
const getFullFileName = require('../helper/getFullFileName')
const makeArchive = require('../helper/makeArchive')
const removeTargetFiles = require('../helper/removeTargetFiles')
const { DBtype } = require('../Config')

const FILE_NAME = 'A5.zip'

const POOL_SIZE = 4
const CONNECTION_TIMEOUT = 20 * 60 * 1000 // 20 minutes
const REQUEST_TIMEOUT = 20 * 60 * 1000 // 20 minutes
const ACQUIRE_TIMEOUT = 20 * 60 * 1000 // 20 minutes

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
        try {
            const pool = config.a5dbType === DBtype.POSTGRES
                ? new Pool(dbConfig(config))
                : config.a5dbType === DBtype.MSSQL
                    ? new sql.ConnectionPool(dbConfig(config))
                    : null
            pool.on('error', (err) => {
                console.log(err)
                sendFailed(err.message)
            })
            await makeDir(config.targetPath)
            const orgID = await getOrgID(config.a5dbType, config.a5Database, config.a5orgCode, pool)
            const orgName = await getOrgName(config.a5dbType, config.a5Database, orgID, pool)
            Promise.all(tableList.map((tableName) => {
                return new Promise((resolve, reject) => {
                    pool.connect()
                        .then(client => {
                            const target = new Target.Target()
                            target.tableName = tableName
                            target.fullFileName = getFullFileName(config.targetPath, tableName + '.csv')
                            target.config = config
                            target.client = client
                            target.orgID = orgID
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
            })).then((targetList) => {
                if (config.isArchive) {
                    const arcFileName = getFullFileName(config.targetPath, orgName ? `${orgName}.zip` : FILE_NAME)
                    makeArchive(arcFileName, targetList)
                        .then(() => removeTargetFiles(targetList))
                        .then(() => sendDone(arcFileName))
                        .catch(err => {
                            sendFailed(err.message)
                        })
                } else {
                    sendDone(null)
                }
            })
        } catch (error) {
            sendFailed(error.message)
        }
    }
}

function dbConfig (config) {
    if (config.a5dbType === DBtype.POSTGRES) {
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
    } else if (config.a5dbType === DBtype.MSSQL) {
        return {
            user: config.a5Login,
            password: config.a5Password,
            server: config.a5Host,
            database: config.a5Database,
            port: Number(config.a5Port),
            connectionTimeout: CONNECTION_TIMEOUT,
            requestTimeout: REQUEST_TIMEOUT,
            pool: {
                max: POOL_SIZE,
                min: 0,
                acquireTimeoutMillis: ACQUIRE_TIMEOUT
            }
        }
    } else {
        throw (new Error(`Unknown dbType (${config.a5dbType}).`))
    }
}

async function getOrgID (dbType, dbName, orgCode, pool) {
    if (!orgCode) return null
    switch (dbType) {
    case DBtype.POSTGRES: {
        const client = await pool.connect()
        const res = await client.query(`select max(ID) ID from ${dbName}.ac_organization where (code = '${orgCode}' or okpocode = '${orgCode}') and mi_deleteDate >= '9999-12-31';`)
        client.release(true)
        return res.rows.length ? res.rows[0].id : null
    }
    case DBtype.MSSQL: {
        const client = await pool.connect()
        const request = await client.request() // or: new sql.Request(pool1)
        const res = await request.query(`select max(ID) ID from ac_organization where (code = '${orgCode}' or okpocode = '${orgCode}') and mi_deleteDate >= '9999-12-31'`)
        return res.recordset.length ? res.recordset[0].ID : null
    }
    default:
        throw new Error(`Unknown dbType (${dbType}).`)
    }
}

async function getOrgName (dbType, dbName, orgID, pool) {
    if (!orgID) return null
    switch (dbType) {
    case DBtype.POSTGRES: {
        const client = await pool.connect()
        const res = await client.query(`select name from ${dbName}.ac_organization where id = ${orgID};`)
        client.release(true)
        return res.rows.length ? res.rows[0].name : null
    }
    case DBtype.MSSQL: {
        const client = await pool.connect()
        const request = await client.request() // or: new sql.Request(pool1)
        const res = await request.query(`select name from ac_organization where id = ${orgID}`)
        return res.recordset.length ? res.recordset[0].name : null
    }
    default:
        throw new Error(`Unknown dbType (${dbType}).`)
    }
}

module.exports = SourceA5
