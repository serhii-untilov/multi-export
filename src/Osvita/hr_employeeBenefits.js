'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const dateFormat = require('../helper/dateFormat')

const Entity = require('../entity/EmployeeBenefits')
const TARGET_FILE_NAME = 'Пільги працівників (hr_employeeBenefits).csv'

function setRecord (record, recordNumber) {
    const ID = Number(record.TAB) + Number(record.BOL) * 10000 * Math.pow(100, record.UWOL || 0)
    this.entity.ID = ID
    this.entity.orgID = record.BOL
    this.entity.employeeID = ID
    this.entity.dictBenefitsKindID = record.KATCHER
    this.entity.dateFrom = record.DATPOST ? dateFormat(record.DATPOST) : ''
    return !!(this.entity.dictBenefitsKindID)
}

function makeTarget (config, dictionary, sourceFile, index) {
    const target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = sourceFile
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    target.append = index > 0
    target.baseDate = new Date(config.osvitaBaseDate || '2022-01-01')
    return makeFile(target)
}

module.exports = makeTarget
