'use strict'

const fullFileName = require('../helper/fullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')

// Be attentive to fill this section
const Entity = require('../entity/EmployeeAccrual')
const SOURCE_FILE_NAME = 'NCH.DBF'
const TARGET_FILE_NAME = 'Постійні нарахування працівника (hr_employeeAccrual).csv'

function makeTarget(config, dictionary) {
    let target = new Target.Target()
    target.fullFileName = fullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = fullFileName(config.c1DbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.entity.setRecord = setRecord
    return makeFile(target)
}

function setRecord(record, recordNumber) {
    this.ID = recordNumber
    this.employeeID = record['TN']
    this.tabNum = record['TN']
    this.taxCode = this.dictionary.get_TaxCode(this.tabNum)
    this.employeeNumberID = record['TN']
    this.payElID = this.dictionary.get_PayElID(record['CD'])
    this.dateFrom = record['DATN'] ? dateFormat(record['DATN']) : ''
    this.dateTo = record['DATK'] ? dateFormat(record['DATK']) : '9999-12-31'
    this.accrualSum = record['SM'] ? record['SM'] : ''
    this.accrualRate = record['PRC'] ? record['PRC'] : ''
    this.orderNumber = record['CDPR']
    this.orderDatefrom = ''
}

module.exports = makeTarget
