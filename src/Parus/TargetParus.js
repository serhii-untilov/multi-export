'use strict'

const fs = require('fs')
const {DBFFile} = require('dbffile')
const removeFile = require('../helper/removeFile')
const Target = require('../Target')

const makeFile = function (target) {
    return new Promise(async (resolve, reject) => {
        try {
            if (!target.append)
                await removeFile(target.fullFileName)
            console.log('target.sourceFullFileName', target.sourceFullFileName)
            fs.exists(target.sourceFullFileName, async (exists) => {
                if (exists) {
                    let buffer = target.append ? '' : target.entity.getHeader()
                    let id = 1

                    let dbf = await DBFFile.open(target.sourceFullFileName)
                    console.log(`DBF file contains ${dbf.recordCount} records.`)
                    console.log(`Field names: ${dbf.fields.map(f => f.name).join(', ')}`)
                    let records = await dbf.readRecords(100)
                    for (let record of records) {
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
