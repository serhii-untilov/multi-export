'use strict'

const fs = require('fs')
const YADBF = require('yadbf')
const removeFile = require('../helper/removeFile')
const fullFileName = require('../helper/fullFileName')
const dateFormat = require('../helper/dateFormat')
const Target = require('../Target')

const makeTarget = function(config, dictionary) {
    return new Promise(async (resolve, reject) => {
        let target = new Target.Target()
        target.fileName = Target.getTargetFileName(config, 'Підрозділи (hr_department)')
        try {
            let sourceFileName = fullFileName(config.c1DbPath, 'PDR.DBF')
            let ID = 0
    
            removeFile(target.fileName)
            let buffer = 'ID;code;name;parentUnitID;state;fullName;description;nameGen;fullNameGen;nameDat;fullNameDat;nameOr;' +
                'fullNameOr;dateFrom;dateTo\n'
    
            fs.createReadStream(sourceFileName)
            .pipe(new YADBF({encoding: 'cp1251'}))
            .on('data', record => {
                if (!record.deleted) {
                    ID += 1
                    let code = record.ID
                    let name = record.NM
                    let parentUnitID = record.ID_PARENT ? dictionary.get_DepartmentID(record.ID_PARENT) : ''
                    let state = 'ACTIVE'
                    let fullName = record.NMF
                    let description = name + ' (' + code + ')'
                    let nameGen = ''
                    let fullNameGen = ''
                    let nameDat =''
                    let fullNameDat = ''            
                    let nameOr = ''
                    let fullNameOr = ''
                    let dateFrom = dateFormat(record.BEG)
                    let dateTo = dateFormat(record.END)
        
                    buffer += `${ID};${code};${name};${parentUnitID};${state};${fullName};${description};`
                    buffer += `${nameGen};${fullNameGen};${nameDat};${fullNameDat};${nameOr};${fullNameOr};`
                    buffer += `${dateFrom};${dateTo}\n`
        
                    target.recordsCount++
                    fs.appendFile(target.fileName, buffer, (err) => {
                            if (err) throw err;
                        })
                    buffer = ''
                    dictionary.set_DepartmentID(code, ID)
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
