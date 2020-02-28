'use strict'

const fs = require('fs')
const YADBF = require('yadbf')
const removeFile = require('../helper/removeFile')
const fullFileName = require('../helper/fullFileName')
const Target = require('../Target')
const WorkSchedule = require('../entity/WorkSchedule')

const makeTarget = function(config, diction) {
    return new Promise(async (resolve, reject) => {
        let target = new Target.Target()
        target.fileName = fullFileName(config.targetPath, 'Графіки роботи (hr_workSchedule).csv')
        try {
            let sourceFileName = fullFileName(config.c1DbPath, 'GRF.DBF')

            removeFile(target.fileName)

            let buffer = new WorkSchedule().getHeader()

            fs.createReadStream(sourceFileName)
            .pipe(new YADBF({encoding: 'cp1251'}))
            .on('data', record => {
                if (!record.deleted) {
                    target.recordsCount++

                    let workSchedule = new WorkSchedule()
                    workSchedule.ID = target.recordsCount
                    workSchedule.code = record.CD
                    workSchedule.name = record.NM
        
                    buffer += workSchedule.getRecord()
                    
                    fs.appendFile(target.fileName, buffer, (err) => {
                            if (err) throw err;
                        })
                    buffer = ''
                    diction.set_WorkScheduleID(workSchedule.code, workSchedule.ID)
                }
            })
            .on('end', () => {
                if (target.recordsCount) {
                    target.state = Target.FILE_CREATED
                } else {
                    target.state = Target.FILE_EMPTY
                }
                resolve(target)
            })
            .on('error', err => {
                console.error(`an error was thrown: ${err}`);
                target.state = Target.FILE_ERROR
                target.err = err
                resolve(target)
            })
        } catch(err) {
            console.error(err)
            reject(err)
        }
    })
}

module.exports = makeTarget
