'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const dateFormat = require('../helper/dateFormat')

const Entity = require('../entity/EmployeeTaxLimit')
const TARGET_FILE_NAME = 'Пільги ПДФО працівників (hr_employeeTaxLimit).csv'

function setRecord (record, recordNumber) {
    if (!record.KOD_PIL || !Number(record.KOD_PIL)) { return false }
    const ID = Number(record.TAB) + Number(record.BOL) * 10000 * Math.pow(100, record.UWOL || 0)
    this.entity.ID = ID
    this.entity.tabNum = record.TAB
    this.entity.employeeID = ID
    this.entity.taxCode = record.IKOD
    this.entity.employeeNumberID = ID
    this.entity.dateFrom = record.DATPOST ? dateFormat(record.DATPOST) : ''
    this.entity.dateTo = record.DATZ ? dateFormat(record.DATZ) : '9999-12-31'
    const taxLimitID = this.dictionary.getTaxLimitID(record.KOD_PIL)
    this.entity.taxLimitID = taxLimitID || ''
    return true
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
