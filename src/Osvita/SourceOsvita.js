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
                .then(() => hr_payEl(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_dictCategoryECB(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_taxLimit(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_dictPosition(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => getFileList(config.osvitaDbPath, employeeFileMask))
                .then((fileList) => { employeeFileList = fileList })
                // Make ac_fundSource
                .then(() => {
                    return Promise.all(
                        employeeFileList.map((sourceFile, index) => {
                            return new Promise(async (resolve, reject) => {
                                ac_fundSource(config, dictionary, sourceFile, index)
                                    .then((target) => {
                                        if (!target.append) { targetList.push(target) }
                                        sendFile(target)
                                        resolve(target)
                                    })
                                    .catch((err) => reject(err))
                            })
                        })
                    )
                })
                // Make hr_payOut
                .then(() => {
                    return Promise.all(
                        employeeFileList.map((sourceFile, index) => {
                            return new Promise(async (resolve, reject) => {
                                hr_payOut(config, dictionary, sourceFile, index)
                                    .then((target) => {
                                        if (!target.append) { targetList.push(target) }
                                        sendFile(target)
                                        resolve(target)
                                    })
                                    .catch((err) => reject(err))
                            })
                        })
                    )
                })
                // Make hr_organization
                .then(() => {
                    return Promise.all(
                        employeeFileList.map((sourceFile, index) => {
                            return new Promise(async (resolve, reject) => {
                                hr_organization(config, dictionary, sourceFile, index)
                                    .then((target) => {
                                        if (!target.append) { targetList.push(target) }
                                        sendFile(target)
                                        resolve(target)
                                    })
                                    .catch((err) => reject(err))
                            })
                        })
                    )
                })
                // Make hr_department
                .then(() => {
                    return Promise.all(
                        employeeFileList.map((sourceFile, index) => {
                            return new Promise(async (resolve, reject) => {
                                hr_department(config, dictionary, sourceFile, index)
                                    .then((target) => {
                                        if (!target.append) { targetList.push(target) }
                                        sendFile(target)
                                        resolve(target)
                                    })
                                    .catch((err) => reject(err))
                            })
                        })
                    )
                })
                // Make hr_employee
                .then(() => {
                    return Promise.all(
                        employeeFileList.map((sourceFile, index) => {
                            return new Promise(async (resolve, reject) => {
                                hr_employee(config, dictionary, sourceFile, index)
                                    .then((target) => {
                                        if (!target.append) { targetList.push(target) }
                                        sendFile(target)
                                        resolve(target)
                                    })
                                    .catch((err) => reject(err))
                            })
                        })
                    )
                })
                // Make hr_employeeNumber
                .then(() => {
                    return Promise.all(
                        employeeFileList.map((sourceFile, index) => {
                            return new Promise(async (resolve, reject) => {
                                hr_employeeNumber(config, dictionary, sourceFile, index)
                                    .then((target) => {
                                        if (!target.append) { targetList.push(target) }
                                        sendFile(target)
                                        resolve(target)
                                    })
                                    .catch((err) => reject(err))
                            })
                        })
                    )
                })
                // Make hr_employeePosition
                .then(() => {
                    return Promise.all(
                        employeeFileList.map((sourceFile, index) => {
                            return new Promise(async (resolve, reject) => {
                                hr_employeePosition(config, dictionary, sourceFile, index)
                                    .then((target) => {
                                        if (!target.append) { targetList.push(target) }
                                        sendFile(target)
                                        resolve(target)
                                    })
                                    .catch((err) => reject(err))
                            })
                        })
                    )
                })
                // Make hr_employeeTaxLimit
                .then(() => {
                    return Promise.all(
                        employeeFileList.map((sourceFile, index) => {
                            return new Promise(async (resolve, reject) => {
                                hr_employeeTaxLimit(config, dictionary, sourceFile, index)
                                    .then((target) => {
                                        if (!target.append) { targetList.push(target) }
                                        sendFile(target)
                                        resolve(target)
                                    })
                                    .catch((err) => reject(err))
                            })
                        })
                    )
                })
                // Make hr_payRetention
                .then(() => {
                    return Promise.all(
                        employeeFileList.map((sourceFile, index) => {
                            return new Promise(async (resolve, reject) => {
                                hr_payRetention(config, dictionary, sourceFile, index)
                                    .then((target) => {
                                        if (!target.append) { targetList.push(target) }
                                        sendFile(target)
                                        resolve(target)
                                    })
                                    .catch((err) => reject(err))
                            })
                        })
                    )
                })
                // Done
                .then(() => {
                    if (config.isArchive) {
                        let arcFileName = getFullFileName(config.targetPath, ARC_FILE_NAME)
                        makeArchive(arcFileName, targetList)
                            .then(() => removeTargetFiles(targetList))
                            .then(() => sendDone(arcFileName))
                            .catch((err) => sendFailed(err.message))
                    } else {
                        sendDone(null)
                    }
                })
                .catch((err) => sendFailed(err.message))
        } catch (err) {
            sendFailed(err.message)
        }
    }
}

module.exports = SourceOsvita
