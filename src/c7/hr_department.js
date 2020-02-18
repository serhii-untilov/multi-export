'use strict'

const fs = require('fs')
const Target = require('../Target')
const Parser = require('node-dbf')

function makeTarget(config, dictionary, sendFile) {
    return new Promise(async (resolve, reject) => {
        try {
            let target = new Target.Target()
            target.fileName = Target.getTargetFileName(config, 'Підрозділи (hr_department)')
            target.config = config
            target.done = sendFile
            target = await makeFile(target, dictionary)
            resolve(true)
        } catch (err) {
            console.log('makeTarget', err)
            reject(err)
        }
    })
}

async function makeFile(target, dictionary) {
    try {
        sourceFileName = getSourceFileName(target.config, 'PDR.DBF')
        let parser = new Parser(sourceFileName);
        let ID = 0

        removeFile(target.fileName)

        let buffer = 'ID;code;name;parentUnitID;state;fullName;description;nameGen;fullNameGen;nameDat;fullNameDat;nameOr;' +
            'fullNameOr;dateFrom;dateTo\n'

        parser.on('start', (p) => {
            console.log('dBase file parsing has started')
        })
         
        parser.on('header', (h) => {
            console.log('dBase file header has been parsed')
        })
         
        parser.on('record', (record) => {
            console.log('dBase file parsing record'); // Name: John Smith
            
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
            let dateFrom = record.BEG
            let dateTo = record.END ? record.END : ''

            buffer += `${ID};${code};${name};${parentUnitID};${state};${fullName};${description};
                ${nameGen};${fullNameGen};${nameDat};${fullNameDat};${nameOr};${fullNameOr};${dateFrom};${dateTo}\n`

            target.recordsCount++
            fs.appendFile(target.fileName, buffer, (err) => {
                    if (err) throw err;
                })
            buffer = ''
            dictionary.setDepartmentID(code, ID)
        })
         
        parser.on('end', (p) => {
            console.log('Finished parsing the dBase file')
            if (target.recordsCount) {
                target.state = Target.FILE_CREATED
                target.done(target)
            } else {
                target.state = Target.FILE_EMPTY
                target.done(target)
            }
        })
        
        parser.parse();
        
        return target
    } catch (err) {
        target.state = Target.FILE_ERROR
        target.err = err
        return target
    }
}

function getSourceFileName(config, sourceFileName) {
    let fileName = path.parse(sourceFileName).name
    let sourcePath = config.c1DbPath[config.c1DbPath.length - 1] == path.sep 
        ? config.c1DbPath 
        : `${config.c1DbPath}${path.sep}`
    let retSourceFileName = `${sourcePath}${fileName}${FILE_EXT}`
    return retSourceFileName
}

function removeFile(fileName) {
    fs.exists(fileName, (exists) => {
        if (exists) {
            fs.unlink(fileName, (err) => { })
        }
    })
}

module.exports = makeTarget
