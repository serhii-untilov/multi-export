'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const { Result } = require('../Target')

const BATCH_SIZE = 10000

const makeFile = function (target) {
    return new Promise((resolve, reject) => {
        readQueryFromFile(target.queryFileName)
            .then((queryText) => replace_orgCode(queryText, target.config.orgCode))
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
            fs.readFile(fileName, { encoding: 'utf8' }, (err, queryText) => {
                if (err) reject(err)
                // Remove BOM if present
                if (queryText.charCodeAt(0) === 0xFEFF) {
                    queryText = queryText.slice(1);
                }
                resolve(queryText)
            })
        } catch (err) {
            reject(err)
        }
    })
}

function replace_orgCode(queryText, orgCode) {
    // const re = /\/\*orgCode\*\//gmi
    const re = /'.*'\s*\/\*orgCode\*\//gim
    while (re.test(queryText)) {
        queryText = queryText.replace(re, "'" + orgCode + "'")
    }
    return queryText
}

async function doQuery(target, queryText) {
    return new Promise((resolve, reject) => {
        removeFile(target.fullFileName)

        const request = target.pool.request() // or: new sql.Request(pool1)
        request.stream = true
        request.query(queryText)

        let buffer = ''

        // Emitted once for each recordset in a query
        request.on('recordset', (columns) => {
            buffer = ''
            writeHeader(columns)
        })

        // Emited for each row in a recordset
        request.on('row', (row) => {
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
        request.on('error', (err) => {
            reject(err)
        })

        // Always emitted as the last one
        request.on('done', (result) => {
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
                    buffer += `${column}`
                }
            }
            buffer += '\n'
        }

        function writeRow(row) {
            let separator = ''
            for (const column in row) {
                // eslint-disable-next-line no-prototype-builtins
                if (row.hasOwnProperty(column)) {
                    const value = replaceSpecialSymbols(String(row[column]))
                    buffer += `${separator}${value}`
                    separator = ';'
                }
            }
            buffer += '\n'
        }
    })
}

module.exports = makeFile
