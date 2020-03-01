'use strict'

const fullFileName = require('../helper/fullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')

// Be attentive to fill this section
const Entity = require('../entity/EmployeePosition')
const SOURCE_FILE_NAME = 'PRK.DBF'
const TARGET_FILE_NAME = 'Призначення працівників (hr_employeePosition).csv'

function setRecord(record, recordNumber) {
    this.ID = recordNumber
    this.tabNum = record['TN']
    this.employeeID = record['TN']
    this.taxCode = dictionary.get_TaxCode(tabNum)
    this.employeeNumberID = record['TN']
    this.departmentID = record['PDR']
    this.positionID = 0 // TODO: Make positionID(departmentID, dictPositionID)
    this.dateFrom = record['BEG'] ? dateFormat(record['BEG']) : ''
    this.dateTo = ''
    this.mtCount = record['STV']
    this.description = ''
    this.dictRankID = record['RAN'] > 0 ? record['RAN'] : ''
    this.dictStaffCatID = record['KAD']
    this.payElID = ''
    this.accrualSum = record['OKL']
}

function makeTarget(config, dictionary) {
    let target = new Target.Target()
    target.fullFileName = fullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = fullFileName(config.c1DbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.entity.setRecord = setRecord
    return makeFile(target)
}

module.exports = makeTarget
