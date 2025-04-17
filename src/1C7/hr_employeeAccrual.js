'use strict'

const getFullFileName = require('../helper/getFullFileName')
const { Target } = require('../Target')
const makeFile = require('./Target1C7')
const dateFormat = require('../helper/dateFormat')

const Entity = require('../entity/EmployeeAccrual')
const SOURCE_FILE_NAME = 'NCH.DBF'
const TARGET_FILE_NAME = 'Постійні нарахування працівника (hr_employeeAccrual).csv'

function setRecord(record, recordNumber) {
    this.entity.ID = recordNumber
    this.entity.employeeID = record.TN
    this.entity.tabNum = record.TN
    this.entity.taxCode = this.dictionary.getTaxCode(this.tabNum)
    this.entity.employeeNumberID = record.TN
    this.entity.payElID = this.dictionary.getPayElID(record.CD)
    this.entity.dateFrom = record.DATN ? dateFormat(record.DATN) : ''
    this.entity.dateTo = record.DATK ? dateFormat(record.DATK) : '9999-12-31'
    this.entity.accrualSum = record.SM ? record.SM : ''
    this.entity.accrualRate = record.PRC ? record.PRC : ''
    this.entity.orderNumber = record.CDPR
    this.entity.orderDatefrom = ''
    return true
}

function makeTarget(config, dictionary) {
    const target = new Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = getFullFileName(config.c1DbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

module.exports = makeTarget
