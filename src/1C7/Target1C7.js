'use strict'

const fs = require('fs')
const YADBF = require('yadbf')
const removeFile = require('../helper/removeFile')
const { Result } = require('../Target')

const makeFile = function (target) {
    return new Promise((resolve, reject) => {
        try {
            if (!target.append) {
                removeFile(target.fullFileName)
            }
            fs.access(target.sourceFullFileName, fs.OK, (err) => {
                if (!err) {
                    let buffer = target.append ? '' : target.entity.getHeader()
                    let id = 1
                    fs.createReadStream(target.sourceFullFileName)
                        .pipe(new YADBF({ encoding: 'cp1251' }))
                        .on('data', (record) => {
                            if (!record.deleted) {
                                if (target.setRecord(record, id)) {
                                    target.recordsCount++
                                    id++
                                    buffer += target.entity.getRecord()
                                    fs.appendFile(target.fullFileName, buffer, (err) => {
                                        if (err) throw err
                                    })
                                    buffer = ''
                                }
                            }
                        })
                        .on('end', () => {
                            target.state = target.recordsCount
                                ? Result.FILE_CREATED
                                : Result.FILE_EMPTY
                            resolve(target)
                        })
                        .on('error', (err) => {
                            console.error(`an error was thrown: ${err}`)
                            target.state = Result.FILE_ERROR
                            target.err = err.message
                            resolve(target)
                        })
                } else {
                    target.state = Result.FILE_EMPTY
                    resolve(target)
                }
            })
        } catch (err) {
            console.error(err)
            reject(err)
        }
    })
}

module.exports = makeFile
