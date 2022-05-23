'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const dateFormat = require('../helper/dateFormat')
const { PAYEL301, PAYEL029 } = require('./hr_payEl')

const Entity = require('../entity/PayRetention')
const TARGET_FILE_NAME = 'Постійні утримання працівників (hr_payRetention).csv'

function setRecord (record, recordNumber) {
    if (this.mapper) this.mapper(record)
    if (this.filter && !this.filter(record)) return false
    if (record.DATZ && record.DATZ < this.baseDate) { return false }
    this.entity = []
    const employeeNumberID = Number(record.TAB) + Number(record.BOL) * 10000 * Math.pow(100, record.UWOL || 0)
    const taxCode = record.IKOD ? record.IKOD : ''

    if (record.PROF === 1) {
        const entity = new Entity()
        entity.ID = employeeNumberID
        entity.tabNum = record.TAB
        entity.employeeID = employeeNumberID
        entity.taxCode = taxCode
        entity.employeeNumberID = employeeNumberID
        entity.dateFrom = record.DATPOST ? dateFormat(record.DATPOST) : ''
        entity.dateTo = record.DATZ ? dateFormat(record.DATZ) : '9999-12-31'
        entity.payElID = PAYEL301
        entity.rate = 1
        this.entity.push(entity)
    }

    if (record.AWAN) {
        const entity = new Entity()
        entity.ID = employeeNumberID
        entity.tabNum = record.TAB
        entity.employeeID = employeeNumberID
        entity.taxCode = taxCode
        entity.employeeNumberID = employeeNumberID
        entity.dateFrom = record.DATPOST ? dateFormat(record.DATPOST) : ''
        entity.dateTo = record.DATZ ? dateFormat(record.DATZ) : '9999-12-31'
        entity.payElID = PAYEL029
        entity.baseSum = record.AWAN
        this.entity.push(entity)
    }

    return !!this.entity.length
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
    target.filter = config.filter
    target.mapper = config.mapper
    return makeFile(target)
}

module.exports = makeTarget
