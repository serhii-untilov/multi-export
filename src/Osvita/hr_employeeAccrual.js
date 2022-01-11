'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const dateFormat = require('../helper/dateFormat')
const { PAYEL178 } = require('./hr_payEl')

const Entity = require('../entity/PayRetention')
const TARGET_FILE_NAME = 'Постійні нарахування працівників (hr_employeeAccrual).csv'

function setRecord (record, recordNumber) {
    if (record.DATZ && record.DATZ < this.baseDate) { return false }
    if (record.OTPUX !== 1) { return false }
    const ID = Number(record.TAB) + Number(record.BOL) * 10000 * Math.pow(100, record.UWOL || 0)

    this.entity.ID = ID
    this.entity.tabNum = record.TAB
    this.entity.employeeID = ID
    this.entity.taxCode = record.IKOD ? record.IKOD : ''
    this.entity.employeeNumberID = ID

    this.entity.dateFrom = dateFormat(this.baseDate) // record.DATPOST ? dateFormat(record.DATPOST) : ''
    this.entity.dateTo = record.DATZ ? dateFormat(record.DATZ) : '9999-12-31'

    this.entity.payElID = PAYEL178
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
