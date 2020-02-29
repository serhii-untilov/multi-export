'use strict'

const fs = require('fs')
const YADBF = require('yadbf')
const removeFile = require('../helper/removeFile')
const fullFileName = require('../helper/fullFileName')
const Target = require('../Target')
const DictStaffCat = require('../entity/SimpleDictionary')

const makeTarget = function(config) {
    return new Promise(async (resolve, reject) => {
        let target = new Target.Target()
        target.fileName = fullFileName(config.targetPath, 'Категорії персоналу (hr_dictStaffCat).csv')
        try {
            let sourceFileName = fullFileName(config.c1DbPath, 'KAT.DBF')

            removeFile(target.fileName)

            let buffer = new DictStaffCat().getHeader()

            fs.createReadStream(sourceFileName)
            .pipe(new YADBF({encoding: 'cp1251'}))
            .on('data', record => {
                if (!record.deleted) {
                    target.recordsCount++

                    let dictPosition = new DictStaffCat()
                    dictPosition.ID = target.recordsCount
                    dictPosition.code = record.CD
                    dictPosition.name = record.NM
        
                    buffer += dictPosition.getRecord()
                    
                    fs.appendFile(target.fileName, buffer, (err) => {
                            if (err) throw err;
                        })
                    buffer = ''
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
