'use strict'

const Source = require('../Source')
const Dictionary = require('../entity/Dictionary')
const makeDir = require('../helper/makeDir')
const getFullFileName = require('../helper/getFullFileName')
const makeArchive = require('../helper/makeArchive')
const removeTargetFiles = require('../helper/removeTargetFiles')
const hr_dictPosition = require('./hr_dictPosition')
const hr_department = require('./hr_department')
const hr_workSchedule = require('./hr_workSchedule')
const hr_dictStaffCat = require('./hr_dictStaffCat')
const setPayElUsed = require('./setPayElUsed')
const hr_payEl = require('./hr_payEl')
const hr_position = require('./hr_position')
const hr_employee = require('./hr_employee')
const hr_employeeNumber = require('./hr_employeeNumber')
const hr_employeePosition = require('./hr_employeePosition')
const hr_employeeAccrual = require('./hr_employeeAccrual')
const hr_accrual = require('./hr_accrual')
const hr_accrual2 = require('./hr_accrual2')
const hr_accrual3 = require('./hr_accrual3')
const hr_accrual4 = require('./hr_accrual4')
const hr_taxLimit = require('./hr_taxLimit')
const setTaxLimitUsed = require('./setTaxLimitUsed')
const hr_employeeTaxLimit = require('./hr_employeeTaxLimit')
// TODO: PUVL.DBF
// TODO: PUVL1.DBF
// TODO: SRNG.DBF
// TODO: SSPS.DBF
// TODO: StVISL.DBF

const ARC_FILE_NAME = '1Cv7.zip'

class Source1C7 extends Source {
    async read (config, sendFile, sendDone, sendFailed) {
        try {
            const targetList = []
            const dictionary = new Dictionary(config)

            makeDir(config.targetPath)
                .then(() => hr_dictPosition(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_department(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_workSchedule(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_dictStaffCat(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => setPayElUsed(config, dictionary))
                .then(() => hr_payEl(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_position(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => setTaxLimitUsed(config, dictionary))
                .then(() => hr_taxLimit(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_employee(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_employeeNumber(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_employeePosition(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_employeeTaxLimit(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_employeeAccrual(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_accrual(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_accrual2(config, dictionary)) // .then((target) => { targetList.push(target); sendFile(target) }) - append mode
                .then(() => hr_accrual3(config, dictionary)) // .then((target) => { targetList.push(target); sendFile(target) }) - append mode
                .then(() => hr_accrual4(config, dictionary)) // .then((target) => { targetList.push(target); sendFile(target) }) - append mode
                .then(() => {
                    if (config.isArchive) {
                        const arcFileName = getFullFileName(config.targetPath, ARC_FILE_NAME)
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

module.exports = Source1C7
