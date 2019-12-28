'use strict'

const sql = require('mssql')
const fs = require('fs')
const Target = require('../Target')

async function makeFile(target) {
    try {
        const queryText = await readQueryFromFile(target.queryFileName)
        await doQuery(target, queryText)
        return target
    } catch (err) {
        target.state = Target.FILE_ERROR
        target.err = err
        return target
    }
}

function readQueryFromFile(fileName) {
    return new Promise((resolve, reject) => {
        fs.readFile(fileName, 'utf8', (err, queryText) => {
            if (err) reject(err);
            resolve(queryText)
        })
    })
}

async function doQuery(target, queryText) {
    try {
        const request = target.pool.request(); // or: new sql.Request(pool1)
        request.stream = true
        request.query(queryText)

        const BATCH_SIZE = 1000
        let buffer = ''

        // Emitted once for each recordset in a query
        request.on('recordset', columns => {
            buffer = ''
            removeFile(target.fileName)
            writeHeader(columns)
        })

        // Emited for each row in a recordset
        request.on('row', row => {
            writeRow(row)
            target.recordsCount++
            if (target.recordsCount % BATCH_SIZE == 0) {
                fs.appendFile(target.fileName, buffer, (err) => {
                    if (err) throw err;
                })
                buffer = ''
            }
        })

        // May be emitted multiple times
        request.on('error', err => {
            console.log('error', err)
        })

        // Always emitted as the last one
        request.on('done', result => {
            if (target.recordsCount) {
                fs.appendFile(target.fileName, buffer, (err) => {
                    if (err) throw err;
                })
                target.state = Target.FILE_CREATED
            } else {
                target.state = Target.FILE_EMPTY
            }
            buffer = ''
        })

        function removeFile(fileName) {
            fs.exists(fileName, (exists) => {
                if (exists) {
                    fs.unlink(fileName, (err) => { })
                }
            })
        }
        
        function writeHeader(columns) {
            let columnNumber = 0
            for (let column in columns) {
                if (columns.hasOwnProperty(column)) {
                    if (columnNumber > 0) buffer += ';'
                    columnNumber++
                    buffer += `${column}`
                }
            }
            buffer += '\n'
        }

        function writeRow(row) {
            let columnNumber = 0
            for (let column in row) {
                if (row.hasOwnProperty(column)) {
                    if (columnNumber > 0) buffer += ';'
                    columnNumber++
                    buffer += `${row[column]}`
                }
            }
            buffer += '\n'
        }
        
    } catch (err) {
        throw err
    }
}

module.exports = makeFile
