'use strict'

const { Version } = require('../Config')
const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const dateFormat = require('../helper/dateFormat')
const { PAYEL178 } = require('./hr_payEl')

const Entity = require('../entity/EmployeeAccrual')
const TARGET_FILE_NAME = 'Постійні нарахування працівників (hr_employeeAccrual).csv'

function setRecord(record, recordNumber) {
    if (this.mapper) this.mapper(record)
    if (this.filter && !this.filter(record)) return false
    const employeeNumberID =
        Number(record.TAB) + Number(record.BOL) * 10000 * Math.pow(100, record.UWOL || 0)
    const taxCode = record.IKOD ? record.IKOD : ''
    this.entity = []
    if (record.OTPUX === 1) {
        const entity = new Entity()
        entity.tabNum = record.TAB
        entity.employeeID = employeeNumberID
        entity.taxCode = taxCode
        entity.employeeNumberID = employeeNumberID
        entity.ID = this.dictionary.getEntityID('hr_employeeAccrual')
        entity.dateFrom = dateFormat(this.baseDate)
        entity.dateTo = record.DATZ ? dateFormat(record.DATZ) : '9999-12-31'
        entity.payElID = PAYEL178
        this.entity.push(entity)
    }
    if (this.version === Version.NO_TARIFFING) {
        for (let i = 1; i <= 9; i++) {
            if (record['DOPKO' + i] && (record['DOPSU' + i] || record['PROC' + i])) {
                const entity = new Entity()
                entity.tabNum = record.TAB
                entity.employeeID = employeeNumberID
                entity.taxCode = taxCode
                entity.employeeNumberID = employeeNumberID
                entity.ID = this.dictionary.getEntityID('hr_employeeAccrual')
                entity.dateFrom = dateFormat(this.baseDate)
                entity.dateTo = record.DATZ ? dateFormat(record.DATZ) : '9999-12-31'
                entity.payElID = record['DOPKO' + i]
                entity.accrualRate = record['PROC' + i]
                if (!entity.accrualRate) {
                    entity.accrualRate = ''
                    entity.accrualSum = record['DOPSU' + i]
                }
                this.entity.push(entity)
            }
        }
    }
    return !!this.entity.length
}

function makeTarget(config, dictionary, sourceFile, index) {
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
    target.version = config.osvitaVersion
    return makeFile(target)
}

module.exports = makeTarget
