'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const dateFormat = require('../helper/dateFormat')
const { PAYEL301 } = require('./hr_payEl')

const Entity = require('../entity/PayRetention')
const TARGET_FILE_NAME = 'Постійні утримання працівників (hr_payRetention).csv'

function setRecord (record, recordNumber) {
    if (record.PROF !== 1) { return false }
    const ID = Number(record.TAB) + Number(record.BOL) * 10000

    this.entity.ID = ID
    this.entity.tabNum = record.TAB
    this.entity.employeeID = ID
    this.entity.taxCode = record.IKOD ? record.IKOD : ''
    this.entity.employeeNumberID = ID

    this.entity.dateFrom = record.DATPOST ? dateFormat(record.DATPOST) : ''
    this.entity.dateTo = record.DATZ ? dateFormat(record.DATZ) : '9999-12-31'

    this.entity.payElID = PAYEL301
    this.entity.rate = 1
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
