'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const { Result } = require('../Target')
const iconv = require('iconv-lite')
const QueryStream = require('pg-query-stream')
// const JSONStream = require('JSONStream')

const BATCH_SIZE = 10000

const makeFile = function (target) {
    return new Promise((resolve, reject) => {
        readQueryFromFile(target.queryFileName)
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
                const convertedQueryText = iconv.decode(queryText, 'utf8')
                resolve(convertedQueryText)
            })
        } catch (err) {
            reject(err)
        }
    })
}

async function doQuery(target, queryText) {
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
                    }
                })
                buffer = ''
                target.state = Result.FILE_CREATED
            } else {
                target.state = Result.FILE_EMPTY
            }
            resolve(target)
        })

        function writeHeader(row) {
            let columnNumber = 0
            for (const column in row) {
                if (columnNumber > 0) buffer += ';'
                columnNumber++
                buffer += `${column}`
            }
            buffer += '\n'
        }

        function writeRow(row) {
            let separator = ''
            for (const column in row) {
                buffer += `${separator}${row[column]}`
                separator = ';'
            }
            buffer += '\n'
        }
    })
}

module.exports = makeFile
