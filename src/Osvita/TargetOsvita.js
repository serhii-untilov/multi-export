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
                        .pipe(
                            new YADBF({
                                encoding: 'cp866' // 'cp1251'
                            })
                        )
                        .on('data', (record) => {
                            if (!record.deleted) {
                                if (target.setRecord(record, id)) {
                                    if (Array.isArray(target.entity)) {
                                        for (let i = 0; i < target.entity.length; i++) {
                                            target.recordsCount++
                                            id++
                                            buffer += target.entity[i].getRecord()
                                            fs.appendFileSync(target.fullFileName, buffer)
                                            buffer = ''
                                        }
                                    } else {
                                        target.recordsCount++
                                        id++
                                        buffer += target.entity.getRecord()
                                        fs.appendFileSync(target.fullFileName, buffer)
                                        buffer = ''
                                    }
                                }
                            }
                        })
                        .on('end', () => {
                            if (buffer.length && target.fullFileName) {
                                fs.appendFileSync(target.fullFileName, buffer)
                                buffer = ''
                            }
                            target.state = target.recordsCount
                                ? Result.FILE_CREATED
                                : Result.FILE_EMPTY
                            resolve(target)
                        })
                        .on('error', (err) => {
                            console.error(
                                `an error was thrown: ${target.sourceFullFileName}: ${err}`
                            )
                            target.state = Result.FILE_ERROR
                            target.err = `${target.sourceFullFileName}: ${err.message}`
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
