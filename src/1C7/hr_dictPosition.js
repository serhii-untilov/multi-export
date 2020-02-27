'use strict'

const fs = require('fs')
const YADBF = require('yadbf')
const removeFile = require('../helper/removeFile')
const fullFileName = require('../helper/fullFileName')
const Target = require('../Target')
const DictPosition = require('../entity/DictPosition')

const makeTarget = function(config) {
    return new Promise(async (resolve, reject) => {
        let target = new Target.Target()
        target.fileName = fullFileName(config.targetPath, 'Довідник посад (не штатних позицій) (hr_dictPosition).csv')
        try {
            let sourceFileName = fullFileName(config.c1DbPath, 'DOL.DBF')

            removeFile(target.fileName)

            let buffer = new DictPosition().getHeader()

            fs.createReadStream(sourceFileName)
            .pipe(new YADBF({encoding: 'cp1251'}))
            .on('data', record => {
                if (!record.deleted) {
                    target.recordsCount++

                    let dictPosition = new DictPosition()
                    dictPosition.ID = record.CD
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
