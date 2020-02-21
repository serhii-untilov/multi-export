'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const Target = require('../Target')
const iconv = require('iconv-lite')

const BATCH_SIZE = 10000

async function makeFile(target) {
    try {
        let queryText = await readQueryFromFile(target.queryFileName)
        queryText = removeHeader(queryText)
        queryText = replace_SYS_SCHEMA(queryText, target.config.schemaSys)
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
        try {
            fs.readFile(fileName, { encoding : null }, (err, queryText) => {
                if (err) reject(err);
                let convertedQueryText = iconv.decode(queryText, 'cp1251');
                resolve(convertedQueryText)
            })
        } catch (err) {
            reject(err)
        }
    })
}

function removeHeader(queryText) {
    let re = /\/\*BEGIN-OF-HEAD\*\/[.\s\W\n\r\w]*\/\*END-OF-HEAD\*\//gmi;
    queryText = queryText.replace(re, '')
    return queryText
}

function replace_SYS_SCHEMA(queryText, schemaSys) {
    // find /*SYS_SCHEMA*/.sspr
    // replace to ${schemaSys}.sspr
    let re = /\/\*SYS_SCHEMA\*\/\w+\./gmi;
    while (re.test(queryText))
        queryText = queryText.replace(re, schemaSys + '.')
    return queryText
}

async function doQuery(target, queryText) {
    try {
        removeFile(target.fileName)

        const request = target.pool.request(); // or: new sql.Request(pool1)
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
            if (target.recordsCount % BATCH_SIZE == 0) {
                request.pause();
                fs.appendFile(target.fileName, buffer, (err) => {
                    if (err) throw err;
                })
                buffer = ''
                request.resume();
            }
        })

        // May be emitted multiple times
        request.on('error', err => {
            throw(err)
        })

        // Always emitted as the last one
        request.on('done', result => {
            
            if (target.recordsCount) {
                // request.pause();
                fs.appendFile(target.fileName, buffer, (err) => {
                    if (err) throw err;
                })
                buffer = ''
                target.state = Target.FILE_CREATED
                target.done(target)
                // request.resume();
            } else {
                target.state = Target.FILE_EMPTY
                target.done(target)
            }
            
        })

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
