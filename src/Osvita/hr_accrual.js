'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const { PAYEL401, PAYEL402, PAYEL403 } = require('./hr_payEl')

const Entity = require('../entity/Accrual')
const TARGET_FILE_NAME = 'Архів розрахункових листів працівників (hr_accrual).csv'

function setRecord (record, recordNumber) {
    this.entity = []
    // Заробіток для розрахунку лікарняного
    const entity0 = new Entity()
    entity0.payElID = PAYEL401
    entity0.ID = this.dictionary.getCommonID()
    entity0.periodCalc = ('' + record.PERIOD).substring(0, 4) + '-' + ('' + record.PERIOD).substring(4, 6) + '-01'
    entity0.periodSalary = entity0.periodCalc
    entity0.tabNum = record.TAB
    entity0.employeeNumberID = Number(record.TAB) + Number(record.BOL) * 10000
    entity0.paySum = record.VIBBOL ? record.VIBBOL : '' // TODO
    entity0.days = record.FAKTDNI ? record.FAKTDNI : ''
    entity0.hours = '' // record.HRS ? record.HRS : ''
    entity0.calculateDate = ''
    entity0.flagsRec = 8 // | (record.STOR > 0 ? 512 : 0) // 8 - import, 512 - storno
    entity0.dateFrom = '' // dateFormat(record.PR_BEG)
    entity0.dateTo = '' // dateFormat(record.PR_END)
    this.entity.push(entity0)

    // Заробіток для розрахунку відпустки
    const entity1 = new Entity()
    entity1.payElID = PAYEL402
    entity1.ID = this.dictionary.getCommonID()
    entity1.periodCalc = ('' + record.PERIOD).substring(0, 4) + '-' + ('' + record.PERIOD).substring(4, 6) + '-01'
    entity1.periodSalary = entity1.periodCalc
    entity1.tabNum = record.TAB
    entity1.employeeNumberID = Number(record.TAB) + Number(record.BOL) * 10000
    entity1.paySum = record.VIBBOL ? record.VIBBOL : '' // TODO
    entity1.days = record.FAKTDNI ? record.FAKTDNI : ''
    entity1.hours = '' // record.HRS ? record.HRS : ''
    entity1.calculateDate = ''
    entity1.flagsRec = 8 // | (record.STOR > 0 ? 512 : 0) // 8 - import, 512 - storno
    entity1.dateFrom = '' // dateFormat(record.PR_BEG)
    entity1.dateTo = '' // dateFormat(record.PR_END)
    this.entity.push(entity1)

    // Заробіток для розрахунку середнього заробітку
    const entity2 = new Entity()
    entity2.payElID = PAYEL403
    entity2.ID = this.dictionary.getCommonID()
    entity1.periodCalc = ('' + record.PERIOD).substring(0, 4) + '-' + ('' + record.PERIOD).substring(4, 6) + '-01'
    entity2.periodSalary = entity1.periodCalc
    entity2.tabNum = record.TAB
    entity2.employeeNumberID = Number(record.TAB) + Number(record.BOL) * 10000
    entity2.paySum = record.VIBBOL ? record.VIBBOL : '' // TODO
    entity2.days = record.FAKTDNI ? record.FAKTDNI : ''
    entity2.hours = '' // record.HRS ? record.HRS : ''
    entity2.calculateDate = ''
    entity2.flagsRec = 8 // | (record.STOR > 0 ? 512 : 0) // 8 - import, 512 - storno
    entity2.dateFrom = '' // dateFormat(record.PR_BEG)
    entity2.dateTo = '' // dateFormat(record.PR_END)
    this.entity.push(entity2)

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
    return makeFile(target)
}

module.exports = makeTarget
