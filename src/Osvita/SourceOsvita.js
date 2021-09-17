'use strict'

const Source = require('../Source')
const Dictionary = require('../entity/Dictionary')
const makeDir = require('../helper/makeDir')
const getFullFileName = require('../helper/getFullFileName')
const makeArchive = require('../helper/makeArchive')
const removeTargetFiles = require('../helper/removeTargetFiles')
const getFileList = require('../helper/getFileList')
const { makeTarget:hr_payEl } = require('./hr_payEl')
const { makeTarget:hr_dictCategoryECB } = require('./hr_dictCategoryECB')
const hr_taxLimit = require('./hr_taxLimit')
const hr_organization = require('./hr_organization')
const hr_department = require('./hr_department')
const hr_dictPosition = require('./hr_dictPosition')
const ac_fundSource = require('./ac_fundSource')
const hr_payOut = require('./hr_payOut')
const hr_employee = require('./hr_employee')
const hr_employeeNumber = require('./hr_employeeNumber')
const hr_employeePosition = require('./hr_employeePosition')
const hr_employeeTaxLimit = require('./hr_employeeTaxLimit')
const hr_payRetention = require('./hr_payRetention')


const ARC_FILE_NAME = 'Osvita.zip'

const employeeFileMask = /^B[0-9]+\.DBF/i

class SourceOsvita extends Source {
    constructor() {
        super()
    }

    async read(config, sendFile, sendDone, sendFailed) {
        try {
            let targetList = []
            let dictionary = new Dictionary(config)
            let employeeFileList = []
            makeDir(config.targetPath)
                .then(() => hr_payEl(config, dictionary)).then((target) => { targetList.push(target); sendFile(target); console.log(1) })
                .then(() => hr_dictCategoryECB(config, dictionary)).then((target) => { targetList.push(target); sendFile(target); console.log(2) })
                .then(() => hr_taxLimit(config, dictionary)).then((target) => { targetList.push(target); sendFile(target); console.log(3) })
                .then(() => hr_dictPosition(config, dictionary)).then((target) => { targetList.push(target); sendFile(target); console.log(4) })
                .then(() => getFileList(config.osvitaDbPath, employeeFileMask))
                .then((fileList) => { employeeFileList = fileList })
                // Make ac_fundSource
                .then( async () => { 
                    for(let i = 0; i < employeeFileList.length; i++) {
                        const target = await ac_fundSource(config, dictionary, employeeFileList[i], i)
                        if (!target.append) { targetList.push(target) }
                        await sendFile(target)
                    }
                })
                // Make hr_payOut
                .then( async () => {
                    for(let i = 0; i < employeeFileList.length; i++) {
                        const target = await hr_payOut(config, dictionary, employeeFileList[i], i)
                        if (!target.append) { targetList.push(target) }
                        await sendFile(target)
                    }
                })
                // Make hr_organization
                .then( async () => {
                    for(let i = 0; i < employeeFileList.length; i++) {
                        const target = await hr_organization(config, dictionary, employeeFileList[i], i)
                        if (!target.append) { targetList.push(target) }
                        await sendFile(target)
                    }
                })
                // Make hr_department
                .then( async () => {
                    for(let i = 0; i < employeeFileList.length; i++) {
                        const target = await hr_department(config, dictionary, employeeFileList[i], i)
                        if (!target.append) { targetList.push(target) }
                        await sendFile(target)
                    }
                })
                // Make hr_employee
                .then( async () => {
                    for(let i = 0; i < employeeFileList.length; i++) {
                        const target = await hr_employee(config, dictionary, employeeFileList[i], i)
                        if (!target.append) { targetList.push(target) }
                        await sendFile(target)
                    }
                })
                // Make hr_employeeNumber
                .then( async () => {
                    for(let i = 0; i < employeeFileList.length; i++) {
                        const target = await hr_employeeNumber(config, dictionary, employeeFileList[i], i)
                        if (!target.append) { targetList.push(target) }
                        await sendFile(target)
                    }
                })
                // Make hr_employeePosition
                .then( async () => {
                    for(let i = 0; i < employeeFileList.length; i++) {
                        const target = await hr_employeePosition(config, dictionary, employeeFileList[i], i)
                        if (!target.append) { targetList.push(target) }
                        await sendFile(target)
                    }
                })
                // Make hr_employeeTaxLimit
                .then( async () => {
                    for(let i = 0; i < employeeFileList.length; i++) {
                        const target = await hr_employeeTaxLimit(config, dictionary, employeeFileList[i], i)
                        if (!target.append) { targetList.push(target) }
                        await sendFile(target)
                    }
                })
                // Make hr_payRetention
                .then( async () => {
                    for(let i = 0; i < employeeFileList.length; i++) {
                        const target = await hr_payRetention(config, dictionary, employeeFileList[i], i)
                        if (!target.append) { targetList.push(target) }
                        await sendFile(target)
                    }
                })
                // Done
                .then( async () => {
                    if (config.isArchive) {
                        let arcFileName = getFullFileName(config.targetPath, ARC_FILE_NAME)
                        await makeArchive(arcFileName, targetList)
                            .then(() => removeTargetFiles(targetList))
                            .then(() => sendDone(arcFileName))
                            .catch((err) => sendFailed(err.message))
                    } else {
                        await sendDone(null)
                    }
                })
                .catch((err) => sendFailed(err.message))
        } catch (err) {
            sendFailed(err.message)
        }
    }
}

module.exports = SourceOsvita
