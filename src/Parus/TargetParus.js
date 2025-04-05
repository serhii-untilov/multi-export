'use strict'

const fs = require('fs')
const { DBFFile } = require('dbffile')
const removeFile = require('../helper/removeFile')
const Target = require('../Target')

const makeFile = function (target) {
    return new Promise((resolve, reject) => {
        try {
            if (!target.append) {
                removeFile(target.fullFileName)
            }
            console.log('target.sourceFullFileName', target.sourceFullFileName)
            fs.access(target.sourceFullFileName, fs.OK, async (err) => {
                if (!err) {
                    let buffer = target.append ? '' : target.entity.getHeader()
                    let id = 1

                    const dbf = await DBFFile.open(target.sourceFullFileName)
                    console.log(`DBF file contains ${dbf.recordCount} records.`)
                    console.log(`Field names: ${dbf.fields.map((f) => f.name).join(', ')}`)
                    const records = await dbf.readRecords(100)
                    for (const record of records) {
                        console.log(record)
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
