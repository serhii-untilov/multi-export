'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const Target = require('../Target')
const QueryStream = require('pg-query-stream')

const { getTableStruct, makeQuery, addWhereOrgID } = require('../helper/db')

const BATCH_SIZE = 10000

const makeFile = function (target) {
    return new Promise((resolve, reject) => {
        getTableStruct(target.config.a5dbType, target.client, target.tableName)
            .then(tableStruct => makeQuery(target.config.a5dbType, target.config.a5Database, target.tableName, tableStruct))
            .then(queryText => {
                return addWhereOrgID(queryText, target.orgID)
            })
            .then(queryText => doQuery(target, queryText))
            .then(() => resolve(target))
            .catch(err => {
                target.state = Target.FILE_ERROR
                target.err = err.message
                resolve(target)
            })
    })
}

async function doQuery (target, queryText) {
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

module.exports = makeFile
