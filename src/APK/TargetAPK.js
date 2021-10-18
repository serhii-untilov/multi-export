'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const Target = require('../Target')
const iconv = require('iconv-lite')
const QueryStream = require('pg-query-stream')

const BATCH_SIZE = 10000

const makeFile = function (target) {
    return new Promise((resolve, reject) => {
        readQueryFromFile(target.queryFileName)
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
            fs.readFile(fileName, { encoding: null }, (err, queryText) => {
                if (err) reject(err)
                const convertedQueryText = iconv.decode(queryText, 'utf8')
                resolve(convertedQueryText)
            })
        } catch (err) {
            reject(err)
        }
    })
}

async function doQuery (target, queryText) {
    return new Promise((resolve, reject) => {
        removeFile(target.fullFileName)
        let buffer = ''
        let printHeader = true
        target.client.query(new QueryStream(queryText))
            .then((stream) => {
                stream.on('error', (err) => { reject(err) })
                stream.on('row', (row, res) => {
                    if (printHeader) {
                        printHeader = false
                        const columns = res.fields.map(o => o.name)
                        writeHeader(columns)
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
                    stream.release()
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
                    buffer += `${separator}${row[column]}`
                    separator = ';'
                }
            }
            buffer += '\n'
        }
    })
}

module.exports = makeFile
