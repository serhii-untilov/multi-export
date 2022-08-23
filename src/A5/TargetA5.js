'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const Target = require('../Target')
const QueryStream = require('pg-query-stream')
const { DBtype } = require('../Config')
const { getTableStruct, makeQuery } = require('../helper/db')

const BATCH_SIZE = 10000

async function makeFile (target) {
    try {
        const tableStruct = await getTableStruct(target.config.a5dbType, target.client, target.tableName)
        let queryText = await makeQuery(target.config.a5dbType, target.config.a5Database, target.tableName, tableStruct)
        queryText = addWhereOrgID(queryText, target.orgID)
        switch (target.config.a5dbType) {
        case DBtype.POSTGRES:
            await doQueryPostgres(target, queryText)
            break
        case DBtype.MSSQL:
            await doQuerySqlServer(target, queryText)
            break
        default:
            throw (new Error(`Unknown dbType (${target.config.a5dbType}).`))
        }
        return target
    } catch (err) {
        target.state = Target.FILE_ERROR
        target.err = err.message
        return target
    }
}

async function doQueryPostgres (target, queryText) {
    return new Promise((resolve, reject) => {
        removeFile(target.fullFileName)
        let buffer = ''
        let printHeader = true
        const query = new QueryStream(queryText)
        const stream = target.client.query(query)
        stream.on('error', (err) => {
            reject(err)
        })
        stream.on('data', (row) => {
            if (printHeader) {
                printHeader = false
                writeHeader(row)
            }
            target.recordsCount++
            writeRow(row)
            if (target.recordsCount % BATCH_SIZE === 0) {
                stream.pause()
                fs.appendFile(target.fullFileName, buffer, (err) => {
                    if (err) throw err
                })
                buffer = ''
                stream.resume()
            }
        })
        stream.on('end', () => {
            if (target.recordsCount) {
                fs.appendFile(target.fullFileName, buffer, (err) => {
                    if (err) {
                        reject(err)
                    };
                })
                buffer = ''
                target.state = Target.FILE_CREATED
            } else {
                target.state = Target.FILE_EMPTY
            }
            resolve(target)
        })

        function writeHeader (row) {
            let columnNumber = 0
            for (const column in row) {
                if (columnNumber > 0) buffer += ';'
                columnNumber++
                buffer += `${column}`
            }
            buffer += '\n'
        }

        function writeRow (row) {
            let separator = ''
            for (const column in row) {
                buffer += `${separator}${row[column] ? row[column] : ''}`
                separator = ';'
            }
            buffer += '\n'
        }
    })
}

async function doQuerySqlServer (target, queryText) {
    return new Promise((resolve, reject) => {
        removeFile(target.fullFileName)

        const request = target.client.request() // or: new sql.Request(pool1)
        request.stream = true
        request.query(queryText)

        let buffer = ''

        // Emitted once for each recordset in a query
        request.on('recordset', columns => {
            buffer = ''
            writeHeader(columns)
        })

        // Emited for each row in a recordset
        request.on('row', row => {
            writeRow(row)
            target.recordsCount++
            if (target.recordsCount % BATCH_SIZE === 0) {
                request.pause()
                fs.appendFile(target.fullFileName, buffer, (err) => {
                    if (err) throw err
                })
                buffer = ''
                request.resume()
            }
        })

        // May be emitted multiple times
        request.on('error', err => {
            reject(err)
        })

        // Always emitted as the last one
        request.on('done', result => {
            if (target.recordsCount) {
                // request.pause();
                fs.appendFile(target.fullFileName, buffer, (err) => {
                    if (err) {
                        reject(err)
                    };
                })
                buffer = ''
                target.state = Target.FILE_CREATED
                // request.resume();
            } else {
                target.state = Target.FILE_EMPTY
            }
            resolve(target)
        })

        function writeHeader (columns) {
            let columnNumber = 0
            for (const column in columns) {
                // eslint-disable-next-line no-prototype-builtins
                if (columns.hasOwnProperty(column)) {
                    if (columnNumber > 0) buffer += ';'
                    columnNumber++
                    buffer += `${column}`
                }
            }
            buffer += '\n'
        }

        function writeRow (row) {
            let separator = ''
            for (const column in row) {
                // eslint-disable-next-line no-prototype-builtins
                if (row.hasOwnProperty(column)) {
                    buffer += `${separator}${row[column] ? row[column] : ''}`
                    separator = ';'
                }
            }
            buffer += '\n'
        }
    })
}

function addWhereOrgID (queryText, orgID) {
    if (queryText.search(/\WorgID\W/gi) >= 0) {
        return queryText + ` where orgID = ${orgID}`
    } else if (queryText.search(/\WorganizationID\W/gi) >= 0) {
        return queryText + ` where organizationID = ${orgID}`
    } else {
        return queryText
    }
}

module.exports = makeFile
