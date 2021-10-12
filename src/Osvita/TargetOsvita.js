'use strict'

const fs = require('fs')
const YADBF = require('yadbf')
const removeFile = require('../helper/removeFile')
const Target = require('../Target')

const makeFile = function (target) {
    return new Promise((resolve, reject) => {
        try {
            if (!target.append) { removeFile(target.fullFileName) }
            fs.access(target.sourceFullFileName, fs.OK, (err) => {
                if (!err) {
                    let buffer = target.append ? '' : target.entity.getHeader()
                    let id = 1
                    fs.createReadStream(target.sourceFullFileName)
                        .pipe(new YADBF({
                            encoding: 'cp866' // 'cp1251'
                        }))
                        .on('data', record => {
                            if (!record.deleted) {
                                if (target.setRecord(record, id)) {
                                    if (Array.isArray(target.entity)) {
                                        for (let i = 0; i < target.entity.length; i++) {
                                            target.recordsCount++
                                            id++
                                            buffer += target.entity[i].getRecord()
                                            fs.appendFile(target.fullFileName, buffer, (err) => {
                                                if (err) throw err
                                            })
                                            buffer = ''
                                        }
                                    } else {
                                        target.recordsCount++
                                        id++
                                        buffer += target.entity.getRecord()
                                        fs.appendFile(target.fullFileName, buffer, (err) => {
                                            if (err) throw err
                                        })
                                        buffer = ''
                                    }
                                }
                            }
                        })
                        .on('end', () => {
                            target.state = target.recordsCount ? Target.FILE_CREATED : Target.FILE_EMPTY
                            resolve(target)
                        })
                        .on('error', err => {
                            console.error(`an error was thrown: ${err}`)
                            target.state = Target.FILE_ERROR
                            target.err = err.message
                            resolve(target)
                        })
                } else {
                    target.state = Target.FILE_EMPTY
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
