'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const { Result } = require('../Target')
const iconv = require('iconv-lite')
const { removeHeader, replace_SYS_SCHEMA, replace_FIRM_SCHEMA, replace_SYSSTE_CD, replace_SPRPDR_CD, remove_SYSSTE } = require('../helper/queryTuner')
const { convertName } = require('../helper/convertName')

const BATCH_SIZE = 10000

const makeFile = function (target) {
    return new Promise((resolve, reject) => {
        readQueryFromFile(target.queryFileName)
            .then((queryText) => removeHeader(queryText))
            .then((queryText) => replace_SYS_SCHEMA(queryText, target.config.schemaSys))
            .then((queryText) => replace_FIRM_SCHEMA(queryText, target.config.schema))
            .then((queryText) => target.config.codeSe ? queryText : remove_SYSSTE(queryText))
            .then((queryText) => replace_SYSSTE_CD(queryText, target.config.codeSe))
            .then((queryText) => replace_SPRPDR_CD(queryText, target.config.codeDep))
            .then((queryText) => doQuery(target, queryText))
            .then(() => resolve(target))
            .catch((err) => {
                target.state = Result.FILE_ERROR
                target.err = err.message
                resolve(target)
            })
    })
}

function readQueryFromFile(fileName) {
    return new Promise((resolve, reject) => {
        try {
            fs.readFile(fileName, { encoding: null }, (err, queryText) => {
                if (err) reject(err)
                const convertedQueryText = iconv.decode(queryText, 'cp1251')
                resolve(convertedQueryText)
            })
        } catch (err) {
            reject(err)
        }
    })
}


async function doQuery(target, queryText) {
    const connection = await target.pool.getConnection()
    return new Promise((resolve, reject) => {
        removeFile(target.fullFileName)

        const stream = connection.queryStream(queryText)
        let buffer = ''

        // Emitted once for each recordset in a query
        stream.on('metadata', (columns) => {
            buffer = ''
            writeHeader(columns)
        })

        // Emited for each row in a recordset
        stream.on('data', (row) => {
            writeRow(row)
            target.recordsCount++
            if (target.recordsCount % BATCH_SIZE === 0) {
                stream.pause()
                fs.appendFile(target.fullFileName, buffer, (err) => {
                    if (err) throw err
                })
                buffer = ''
                stream.resume()
            }
        })

        // May be emitted multiple times
        stream.on('error', (err) => {
            reject(err)
        })

        // Always emitted as the last one
        stream.on('end', (result) => {
            if (target.recordsCount) {
                // request.pause();
                fs.appendFile(target.fullFileName, buffer, (err) => {
                    if (err) {
                        reject(err)
                    }
                })
                buffer = ''
                target.state = Result.FILE_CREATED
                // request.resume();
            } else {
                target.state = Result.FILE_EMPTY
            }
            resolve(target)
        })

        function writeHeader(columns) {
            let columnNumber = 0
            for (const column in columns) {
                // eslint-disable-next-line no-prototype-builtins
                if (columns.hasOwnProperty(column)) {
                    if (columnNumber > 0) buffer += ';'
                    columnNumber++
                    const name = convertName(columns[column].name)
                    buffer += `${name}`
                }
            }
            buffer += '\n'
        }

        function writeRow(row) {
            let separator = ''
            for (const column in row) {
                // eslint-disable-next-line no-prototype-builtins
                if (row.hasOwnProperty(column)) {
                    buffer += `${separator}${row[column]}`
                    separator = ';'
                }
            }
            buffer += '\n'
        }
    })
}

module.exports = makeFile
