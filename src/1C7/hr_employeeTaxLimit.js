'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')
const dateFormat = require('../helper/dateFormat')

// Be attentive to fill this section
const Entity = require('../entity/EmployeeTaxLimit')
const SOURCE_FILE_NAME = 'PLG.DBF'
const TARGET_FILE_NAME = 'Пільги ПДФО працівників (hr_employeeTaxLimit).csv'

function setRecord(record, recordNumber) {
    this.entity.ID = recordNumber
    this.entity.tabNum = record.TN
    this.entity.employeeID = record.TN
    this.entity.taxCode = this.dictionary.getTaxCode(this.entity.tabNum)
    this.entity.employeeNumberID = record.TN
    this.entity.dateFrom = dateFormat(record.DATN)
    this.entity.dateTo = '9999-12-31'
    let taxLimitID = this.dictionary.getTaxLimitID(record.CD)
    this.entity.taxLimitID = taxLimitID ? taxLimitID : ''
    return true
}

function makeTarget(config, dictionary) {
    let target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourcegetFullFileName = getFullFileName(config.c1DbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

module.exports = makeTarget
