'use strict'

const fs = require('fs')
const YADBF = require('yadbf')
const removeFile = require('../helper/removeFile')
const fullFileName = require('../helper/fullFileName')
const dateFormat = require('../helper/dateFormat')
const Target = require('../Target')
const Department = require('../entity/Department')

const makeTarget = function(config, dictionary) {
    return new Promise(async (resolve, reject) => {
        let target = new Target.Target()
        target.fileName = fullFileName(config.targetPath, 'Підрозділи (hr_department).csv')
        try {
            let sourceFileName = fullFileName(config.c1DbPath, 'PDR.DBF')

            removeFile(target.fileName)

            let buffer = new Department().getHeader()

            fs.createReadStream(sourceFileName)
            .pipe(new YADBF({encoding: 'cp1251'}))
            .on('data', record => {
                if (!record.deleted) {
                    target.recordsCount++

                    let department = new Department()
                    department.ID = target.recordsCount
                    department.code = record.ID
                    department.name = record.NM
                    department.parentUnitID = record.ID_PARENT ? dictionary.get_DepartmentID(record.ID_PARENT) : ''
                    department.fullName = record.NMF
                    department.description = department.name + ' (' + department.code + ')'
                    department.dateFrom = dateFormat(record.BEG)
                    department.dateTo = dateFormat(record.END)
        
                    buffer += department.getRecord()
                    
                    fs.appendFile(target.fileName, buffer, (err) => {
                            if (err) throw err;
                        })
                    buffer = ''
                    dictionary.set_DepartmentID(department.code, department.ID)
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
