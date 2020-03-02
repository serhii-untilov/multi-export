'use strict'

const fs = require('fs')
const YADBF = require('yadbf')
const removeFile = require('../helper/removeFile')
const Target = require('../Target')

const makeFile = function (target) {
    return new Promise(async (resolve, reject) => {
        try {
            removeFile(target.fullFileName)
            fs.exists(target.sourceFullFileName, (exists) => {
                if (exists) {
                    let buffer = target.entity.getHeader()
                    fs.createReadStream(target.sourceFullFileName)
                        .pipe(new YADBF({ encoding: 'cp1251' }))
                        .on('data', record => {
                            if (!record.deleted) {
                                target.recordsCount++
                                target.setRecord(record, target.recordsCount)
                                buffer += target.entity.getRecord()
                                fs.appendFile(target.fullFileName, buffer, (err) => {
                                    if (err) throw err
                                })
                                buffer = ''
                            }
                        })
                        .on('end', () => {
                            target.state = target.recordsCount ? Target.FILE_CREATED : Target.FILE_EMPTY
                            resolve(target)
                        })
                        .on('error', err => {
                            console.error(`an error was thrown: ${err}`);
                            target.state = Target.FILE_ERROR
                            target.err = err
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
