'use strict'

const getFullFileName = require('../helper/getFullFileName')
const { Target } = require('../Target')
const makeFile = require('./TargetOsvita')
const { PAYEL401, PAYEL402, PAYEL403 } = require('./hr_payEl')

const Entity = require('../entity/Accrual')
const TARGET_FILE_NAME = 'Архів розрахункових листів працівників (hr_accrual).csv'

// const minDate = new Date(new Date().getFullYear() - 1, 0, 1)
const currentDate = new Date()
const minDate = new Date(currentDate.setMonth(currentDate.getMonth() - 14))

function setRecord(record, recordNumber) {
    if (this.mapper) this.mapper(record)
    if (this.filter && !this.filter(record)) return false
    this.entity = []

    const year = Number(('' + record.PERIOD).substring(0, 4))
    const month = Number(('' + record.PERIOD).substring(4, 6))
    const periodCalc =
        ('' + record.PERIOD).substring(0, 4) + '-' + ('' + record.PERIOD).substring(4, 6) + '-01'

    if (new Date(periodCalc) < minDate) {
        return false
    }

    const daysInMonth = new Date(year, month, 0).getDate()
    const employeeNumberID = Number(record.TAB) + Number(record.BOL) * 10000
    if (!this.dictionary.findEmployeeNumberID(employeeNumberID)) return false

    // Заробіток для розрахунку лікарняного
    const entity0 = new Entity()
    entity0.payElID = PAYEL401
    entity0.ID = this.dictionary.getCommonID()
    entity0.periodCalc = periodCalc
    entity0.periodSalary = periodCalc
    entity0.tabNum = record.TAB
    entity0.employeeNumberID = employeeNumberID
    entity0.paySum =
        (record.VIBBOL || 0) +
        (record.OTPSUM || 0) +
        (record.OTCHS || 0) +
        (record.OFMP || 0) +
        (record.ODOPS || 0)
    entity0.days = daysInMonth
    entity0.flagsRec = 8 // | (record.STOR > 0 ? 512 : 0) // 8 - import, 512 - storno
    entity0.dictProgClassID = this.dictionary.getDictProgClassID(entity0.employeeNumberID)
    entity0.dictFundSourceID = this.dictionary.getDictFundSourceID(entity0.employeeNumberID)
    if (entity0.paySum > 0 && entity0.days > 0) {
        this.entity.push(entity0)
    }

    // Заробіток для розрахунку відпустки
    const entity1 = new Entity()
    entity1.payElID = PAYEL402
    entity1.ID = this.dictionary.getCommonID()
    entity1.periodCalc = periodCalc
    entity1.periodSalary = periodCalc
    entity1.tabNum = record.TAB
    entity1.employeeNumberID = employeeNumberID
    entity1.paySum = record.SUMOTP || ''
    if (daysInMonth) {
        entity1.days = (daysInMonth || 0) - (record.ADMDNI || 0)
    }
    entity1.flagsRec = 8 // | (record.STOR > 0 ? 512 : 0) // 8 - import, 512 - storno
    entity1.dictProgClassID = this.dictionary.getDictProgClassID(entity1.employeeNumberID)
    entity1.dictFundSourceID = this.dictionary.getDictFundSourceID(entity1.employeeNumberID)
    if (entity1.paySum > 0 && entity1.days > 0) {
        this.entity.push(entity1)
    }

    // Заробіток для розрахунку середнього заробітку
    const entity2 = new Entity()
    entity2.payElID = PAYEL403
    entity2.ID = this.dictionary.getCommonID()
    entity2.periodCalc = periodCalc
    entity2.periodSalary = periodCalc
    entity2.tabNum = record.TAB
    entity2.employeeNumberID = employeeNumberID
    entity2.paySum = record.SUMOTP || ''
    if (daysInMonth) {
        entity2.days = (daysInMonth || 0) - (record.ADMDNI || 0)
    }
    entity2.flagsRec = 8 // | (record.STOR > 0 ? 512 : 0) // 8 - import, 512 - storno
    entity2.dictProgClassID = this.dictionary.getDictProgClassID(entity2.employeeNumberID)
    entity2.dictFundSourceID = this.dictionary.getDictFundSourceID(entity2.employeeNumberID)
    if (entity2.paySum > 0 && entity2.days > 0) {
        this.entity.push(entity2)
    }

    return true
}

function makeTarget(config, dictionary, sourceFile, index) {
    const target = new Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = sourceFile
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    target.append = index > 0
    target.filter = config.filter
    target.mapper = config.mapper
    return makeFile(target)
}

module.exports = makeTarget
