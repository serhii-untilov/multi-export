'use strict'

const Source = require('../Source')
const Dictionary = require('../entity/Dictionary')
const makeDir = require('../helper/makeDir')
const getFullFileName = require('../helper/getFullFileName')
const makeArchive = require('../helper/makeArchive')
const removeTargetFiles = require('../helper/removeTargetFiles')
const getFileList = require('../helper/getFileList')
const { makeTarget: hr_payEl } = require('./hr_payEl')
const { makeTarget: hr_dictCategoryECB } = require('./hr_dictCategoryECB')
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
    async read (config, sendFile, sendDone, sendFailed) {
        try {
            const targetList = []
            const dictionary = new Dictionary(config)
            let employeeFileList = []
            makeDir(config.targetPath)
                // Sources
                .then(() => hr_payEl(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_dictCategoryECB(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_taxLimit(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_dictPosition(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => getFileList(config.osvitaDbPath, employeeFileMask))
                .then((fileList) => { employeeFileList = fileList })
                .then(async () => {
                    const sourceList = [
                        ac_fundSource,
                        hr_payOut,
                        hr_organization,
                        hr_department,
                        hr_employee,
                        hr_employeeNumber,
                        hr_employeePosition,
                        hr_employeeTaxLimit,
                        hr_payRetention
                    ]
                    for (let i = 0; i < sourceList.length; i++) {
                        for (let j = 0; j < employeeFileList.length; j++) {
                            const target = await sourceList[i](config, dictionary, employeeFileList[j], j)
                            if (!target.append) { targetList.push(target) }
                            await sendFile(target)
                        }
                    }
                })
                // Done
                .then(async () => {
                    if (config.isArchive) {
                        const arcFileName = getFullFileName(config.targetPath, ARC_FILE_NAME)
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
