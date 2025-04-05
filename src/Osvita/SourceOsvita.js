'use strict'

const { Version } = require('../Config')
const Source = require('../Source')
const Target = require('../Target')
const Dictionary = require('../entity/Dictionary')
const makeDir = require('../helper/makeDir')
const getFullFileName = require('../helper/getFullFileName')
const makeArchive = require('../helper/makeArchive')
const removeTargetFiles = require('../helper/removeTargetFiles')
const { getAllFiles } = require('../helper/getFileList')
const { makeTarget: hr_payEl } = require('./hr_payEl')
const { makeTarget: hr_dictCategoryECB } = require('./hr_dictCategoryECB')
const hr_taxLimit = require('./hr_taxLimit')
const DO = require('./DO')
const hr_department = require('./hr_department')
const hr_dictPosition = require('./hr_dictPosition')
const ac_fundSource = require('./ac_fundSource')
const hr_payOut = require('./hr_payOut')
const hr_employee = require('./hr_employee')
const hr_employeeNumber = require('./hr_employeeNumber')
const hr_employeePosition = require('./hr_employeePosition')
const hr_employeeTaxLimit = require('./hr_employeeTaxLimit')
const hr_payRetention = require('./hr_payRetention')
const hr_dictStaffCat = require('./hr_dictStaffCat')
const hr_accrual = require('./hr_accrual')
const hr_workSchedule = require('./hr_workSchedule')
const S_BAN = require('./S_BAN')
const ac_dictdockind = require('./ac_dictdockind')
const hr_employeeDocs = require('./hr_employeeDocs')
const ac_addresses = require('./ac_addresses')
const hr_dictBenefitsKind = require('./hr_dictBenefitsKind')
const hr_employeeBenefits = require('./hr_employeeBenefits')
const hr_dictExperience = require('./hr_dictExperience')
const hr_employeeExperience = require('./hr_employeeExperience')
const hr_organization = require('./hr_organization')
const cdn_country = require('./cdn_country')
const hr_dictTarifCoeff = require('./hr_dictTarifCoeff')
const S = require('./S')
const hr_dictEducationLevel = require('./hr_dictEducationLevel')
const hr_employeeEducation = require('./hr_employeeEducation')
const hr_employeeAccrual = require('./hr_employeeAccrual')
const ac_dictProgClass = require('./ac_dictProgClass')
const path = require('path')

const ARC_FILE_NAME = 'Osvita.zip'

const MARGIN_DATE = new Date(new Date().getFullYear(), 0, 1)

class SourceOsvita extends Source {
    async read(config, sendFile, sendDone, sendFailed) {
        const fieldsMap = [{ DATUWOL: 'DATZ' }]
        if (config.osvitaVersion === Version.NO_TARIFFING) {
            config.mapper = (record) => {
                fieldsMap.forEach((o) => {
                    const source = Object.keys(o)[0]
                    const destination = Object.values(o)[0]
                    if (source in record && destination in record) {
                        record[destination] = record[source]
                    }
                })
            }
        }
        config.filter = (record) => {
            if (
                config.osvitaVersion === Version.NO_TARIFFING &&
                config.osvitaDepartment.length &&
                'OTD' in record &&
                record.OTD.toString() !== config.osvitaDepartment
            ) {
                return false
            }
            if (record.DATZ && record.DATZ < MARGIN_DATE) {
                return false
            }
            return true
        }
        try {
            const targetList = []
            const dictionary = new Dictionary(config)
            makeDir(config.targetPath)
                .then(() => hr_payEl(config, dictionary))
                .then((target) => {
                    targetList.push(target)
                    sendFile(target)
                })
                .then(() => hr_dictEducationLevel(config, dictionary))
                .then((target) => {
                    targetList.push(target)
                    sendFile(target)
                })
                .then(() => ac_fundSource(config, dictionary))
                .then((target) => {
                    targetList.push(target)
                    sendFile(target)
                })
                .then(() => hr_dictCategoryECB(config, dictionary))
                .then((target) => {
                    targetList.push(target)
                    sendFile(target)
                })
                .then(() => hr_workSchedule(config, dictionary))
                .then((target) => {
                    targetList.push(target)
                    sendFile(target)
                })
                .then(() => ac_dictdockind(config, dictionary))
                .then((target) => {
                    targetList.push(target)
                    sendFile(target)
                })
                .then(() => hr_dictBenefitsKind(config, dictionary))
                .then((target) => {
                    targetList.push(target)
                    sendFile(target)
                })
                .then(() => hr_dictExperience(config, dictionary))
                .then((target) => {
                    targetList.push(target)
                    sendFile(target)
                })
                .then(() => cdn_country(config, dictionary))
                .then((target) => {
                    targetList.push(target)
                    sendFile(target)
                })
                .then(() => hr_dictTarifCoeff(config, dictionary))
                .then((target) => {
                    targetList.push(target)
                    sendFile(target)
                })
                .then(() => getAllFiles(config.osvitaDbPath, /^S[0-9]+\.DBF/i))
                .then(async (fileList) => {
                    for (let j = 0; j < fileList.length; j++) {
                        await S(config, dictionary, fileList[j], j)
                    }
                })
                .then(() => getAllFiles(config.osvitaDbPath, /^B[0-9]+\.DBF/i))
                .then(async (fileList) => {
                    for (let j = 0; j < fileList.length; j++) {
                        await ac_dictProgClass(config, dictionary, fileList[j], j)
                    }
                })
                .then(() => getAllFiles(config.osvitaDbPath, /^DO[0-9]+\.DBF/i))
                .then(async (fileList) => {
                    for (let j = 0; j < fileList.length; j++) {
                        await DO(config, dictionary, fileList[j], j)
                    }
                })
                .then(() => getAllFiles(config.osvitaDbPath, /^S_BAN.DBF/i))
                .then(async (fileList) => {
                    for (let j = 0; j < fileList.length; j++) {
                        await S_BAN(config, dictionary, fileList[j], j)
                    }
                })
                .then(() => getAllFiles(config.osvitaDbPath, /^SOCPIL.DBF/i))
                .then(async (fileList) => {
                    for (let j = 0; j < fileList.length; j++) {
                        const target = await hr_taxLimit(config, dictionary, fileList[j], j)
                        pushTarget(targetList, target)
                        await sendFile(target)
                    }
                })
                .then(() => getAllFiles(config.osvitaDbPath, /^SPRA_DOL.DBF/i))
                .then(async (fileList) => {
                    for (let j = 0; j < fileList.length; j++) {
                        const target = await hr_dictPosition(config, dictionary, fileList[j], j)
                        pushTarget(targetList, target)
                        await sendFile(target)
                    }
                })
                .then(() => getAllFiles(config.osvitaDbPath, /^KATEGOR.DBF/i))
                .then(async (fileList) => {
                    for (let j = 0; j < fileList.length; j++) {
                        const target = await hr_dictStaffCat(config, dictionary, fileList[j], j)
                        pushTarget(targetList, target)
                        await sendFile(target)
                    }
                })
                .then(() => getAllFiles(config.osvitaDbPath, /^B[0-9]+\.DBF/i))
                .then(async (fileList) => {
                    const sourceList = [
                        hr_payOut,
                        hr_organization,
                        hr_department,
                        hr_employee,
                        hr_employeeNumber,
                        hr_employeePosition,
                        hr_employeeTaxLimit,
                        hr_payRetention,
                        hr_employeeDocs,
                        ac_addresses,
                        hr_employeeBenefits,
                        hr_employeeExperience,
                        hr_employeeEducation,
                        hr_employeeAccrual
                    ]
                    for (let i = 0; i < sourceList.length; i++) {
                        for (let j = 0; j < fileList.length; j++) {
                            if (
                                config.osvitaVersion === Version.NO_TARIFFING &&
                                config.osvitaOrganization.length &&
                                organizationNumber(fileList[j]) !== config.osvitaOrganization
                            )
                                continue
                            const target = await sourceList[i](config, dictionary, fileList[j], j)
                            pushTarget(targetList, target)
                            await sendFile(target)
                        }
                    }
                })
                .then(() => getAllFiles(config.osvitaDbPath, /^D[0-9]+\.DBF/i))
                .then(async (fileList) => {
                    const sourceList = [hr_accrual]
                    for (let i = 0; i < sourceList.length; i++) {
                        for (let j = 0; j < fileList.length; j++) {
                            const target = await sourceList[i](config, dictionary, fileList[j], j)
                            pushTarget(targetList, target)
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

function pushTarget(targetList, target) {
    const update = targetList.find((o) => o.fullFileName === target.fullFileName)
    if (update) {
        update.recordsCount += target.recordsCount
        if (update.recordsCount) {
            update.state = Target.FILE_CREATED
        }
    } else {
        targetList.push(target)
    }
}

function organizationNumber(fileName) {
    const name = path.parse(fileName).name
    return name[name.length - 1]
}

module.exports = SourceOsvita
