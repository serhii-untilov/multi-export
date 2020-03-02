'use strict'

const fullFileName = require('../helper/fullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')
const dateFormat = require('../helper/dateFormat')

// Be attentive to fill this section
const Entity = require('../entity/EmployeePosition')
const SOURCE_FILE_NAME = 'PRK.DBF'
const TARGET_FILE_NAME = 'Призначення працівників (hr_employeePosition).csv'

function setRecord(record, recordNumber) {
    this.entity.ID = recordNumber
    this.entity.tabNum = record['TN']
    this.entity.employeeID = record['TN']
    this.entity.taxCode = this.dictionary.getTaxCode(this.entity.tabNum)
    this.entity.employeeNumberID = record['TN']
    this.entity.departmentID = record['PDR']
    this.entity.positionID = 0 // TODO: Make positionID(departmentID, dictPositionID)
    this.entity.dateFrom = record['BEG'] ? dateFormat(record['BEG']) : ''
    this.entity.dateTo = ''
    this.entity.mtCount = record['STV']
    this.entity.description = ''
    this.entity.dictRankID = record['RAN'] > 0 ? record['RAN'] : ''
    this.entity.dictStaffCatID = record['KAD']
    this.entity.payElID = ''
    this.entity.accrualSum = record['OKL']
}

function makeTarget(config, dictionary) {
    let target = new Target.Target()
    target.fullFileName = fullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = fullFileName(config.c1DbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

module.exports = makeTarget
