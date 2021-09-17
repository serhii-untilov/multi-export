'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')
const dateFormat = require('../helper/dateFormat')
const makePositionID = require('../helper/makePositionID')

// Be attentive to fill this section
const Entity = require('../entity/EmployeePosition')
const SOURCE_FILE_NAME = 'PRK.DBF'
const TARGET_FILE_NAME = 'Призначення працівників (hr_employeePosition).csv'

function setRecord(record, recordNumber) {
    let inheritance = record.TN === this.entity.tabNum ? true : false

    this.entity.ID = recordNumber
    this.entity.tabNum = record.TN
    this.entity.employeeID = record.TN
    this.entity.taxCode = this.dictionary.getTaxCode(this.entity.tabNum)
    this.entity.employeeNumberID = record.TN

    if (record.PDR || !inheritance)
        this.entity.departmentID = this.dictionary.getDepartmentID(record.PDR)
    if (record.DOL || !inheritance)
        this.entity.dictPositionID = record.DOL
    this.entity.positionID = makePositionID(this.entity.departmentID, this.entity.dictPositionID) 
    this.entity.dateFrom = record.BEG ? dateFormat(record.BEG) : ''
    this.entity.dateTo = ''
    if (record.STV || !inheritance)
        this.entity.mtCount = record.STV
    
    let fullName = this.dictionary.getEmployeeFullName(this.entity.employeeID)
    let positionName = this.dictionary.getDictPositionName(this.entity.dictPositionID)
    this.entity.description = `${this.entity.tabNum} ${fullName} ${positionName}`

    if (record.RAN || !inheritance)
        this.entity.dictRankID = record.RAN > 0 ? record.RAN : ''
    if (record.KAD || !inheritance)
        this.entity.dictStaffCatID = this.dictionary.getDictStaffCatID(record.KAD)
    this.entity.payElID = ''
    if (record.OKL || !inheritance)
        this.entity.accrualSum = record.OKL

    let catID = this.dictionary.getDictStaffCatID(record.KAD)
    let dictStaffCatID = this.dictionary.getDictStaffCatID_WorkScheduleID(catID)
    if (dictStaffCatID || !inheritance)
        this.entity.dictStaffCatID = dictStaffCatID
    
    return true
}

function makeTarget(config, dictionary) {
    let target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = getFullFileName(config.c1DbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

module.exports = makeTarget
