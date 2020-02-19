'use strict'

const fs = require('fs')
const path = require('path')
const Target = require('../Target')
const YADBF = require('yadbf')

const makeTarget = function(config, dictionary, sendFile) {
    return new Promise(async (resolve) => {
        let target = new Target.Target()
        target.fileName = Target.getTargetFileName(config, 'Підрозділи (hr_department)')
        target.config = config
        target.done = sendFile
        console.log('before makeFile')
        target = await makeFile(target, dictionary)
        resolve(target)
    })
}

async function makeFile(target, dictionary) {
    console.log('makeFile')
    try {
        let sourceFileName = getSourceFileName(target.config, 'PDR.DBF')
        let ID = 0

        removeFile(target.fileName)
        let buffer = 'ID;code;name;parentUnitID;state;fullName;description;nameGen;fullNameGen;nameDat;fullNameDat;nameOr;' +
            'fullNameOr;dateFrom;dateTo\n'

        fs.createReadStream(sourceFileName)
        .pipe(new YADBF())
        .on('header', header => {
            console.log(`header: ${JSON.stringify(header, null, 2)}`);
        })
        .on('data', record => {
            console.log(`record: ${JSON.stringify(record, null, 2)}`);

            if (!record.deleted) {
                ID += 1
                let code = record.ID
                let name = record.NM
                let parentUnitID = record.ID_PARENT // ? dictionary.get_DepartmentID(record.ID_PARENT) : ''
                let state = 'ACTIVE'
                let fullName = record.NMF
                let description = name + ' (' + code + ')'
                let nameGen = ''
                let fullNameGen = ''
                let nameDat =''
                let fullNameDat = ''            
                let nameOr = ''
                let fullNameOr = ''
                let dateFrom = record.BEG
                let dateTo = record.END ? record.END : ''
    
                buffer += `${ID};${code};${name};${parentUnitID};${state};${fullName};${description};
                    ${nameGen};${fullNameGen};${nameDat};${fullNameDat};${nameOr};${fullNameOr};${dateFrom};${dateTo}\n`
    
                target.recordsCount++
                fs.appendFile(target.fileName, buffer, (err) => {
                        if (err) throw err;
                    })
                buffer = ''
            }
            // dictionary.setDepartmentID(code, ID)
        })
        .on('end', () => {
            console.log('Done!', target.recordsCount);
            if (target.recordsCount) {
                target.state = Target.FILE_CREATED
                target.done(target)
            } else {
                target.state = Target.FILE_EMPTY
                target.done(target)
            }
            console.log('Finished parsing the dBase file')
            return target
        })
        .on('error', err => {
            console.error(`an error was thrown: ${err}`);
            target.state = Target.FILE_ERROR
            target.err = err
            return target
        })

    } catch (err) {
        console.log(err)
        target.state = Target.FILE_ERROR
        target.err = err
        return target
    }
}

function getSourceFileName(config, fileName) {
    console.log('getSourceName', 1)
    let pathFileName = config.c1DbPath[config.c1DbPath.length - 1] == path.sep 
        ? `${config.c1DbPath}${fileName}`
        : `${config.c1DbPath}${path.sep}${fileName}`
        console.log('getSourceName', 2, pathFileName)
    return pathFileName
}

function removeFile(fileName) {
    fs.exists(fileName, (exists) => {
        if (exists) {
            fs.unlink(fileName, (err) => { })
        }
    })
}

module.exports = makeTarget
