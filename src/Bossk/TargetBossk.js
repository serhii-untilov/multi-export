'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const Target = require('../Target')

const BATCH_SIZE = 10000

const makeFile = function (target) {
    return new Promise((resolve, reject) => {
        readQueryFromFile(target.queryFileName)
            .then((queryText) => replace_OKPO(queryText, target.config.orgCode))
            .then((queryText) => doQuery(target, queryText))
            .then(() => resolve(target))
            .catch((err) => {
                target.state = Target.FILE_ERROR
                target.err = err.message
                resolve(target)
            })
    })
}

function readQueryFromFile (fileName) {
    return new Promise((resolve, reject) => {
        try {
            fs.readFile(fileName, { encoding: 'utf8' }, (err, queryText) => {
                if (err) reject(err)
                resolve(queryText)
            })
        } catch (err) {
            reject(err)
        }
    })
}

function replace_OKPO (queryText, okpo) {
    // const re = /\/\*OKPO\*\//gmi
    const re = /'.*'\s*\/\*OKPO\*\//gmi
    while (re.test(queryText)) {
        queryText = queryText.replace(re, '\'' + okpo + '\'')
    }
    return queryText
}

async function doQuery (target, queryText) {
    return new Promise((resolve, reject) => {
        removeFile(target.fullFileName)

        const request = target.pool.request() // or: new sql.Request(pool1)
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
                    const cell = (row[column]).replace(/\n/, ' ').trim()
                    buffer += `${separator}${cell}`
                    separator = ';'
                }
            }
            buffer += '\n'
        }
    })
}

module.exports = makeFile
