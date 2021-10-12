'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const dateFormat = require('../helper/dateFormat')
// const makePositionID = require('../helper/makePositionID')
const { PAYEL146, PAYEL147, PAYEL246, PAYEL247, PAYEL248 } = require('./hr_payEl')
const { ECB1, ECB2 } = require('./hr_dictCategoryECB')
const path = require('path')

const Entity = require('../entity/EmployeePosition')
const TARGET_FILE_NAME = 'Призначення працівників (hr_employeePosition).csv'

function setRecord (record, recordNumber) {
    const ID = Number(record.TAB) + Number(record.BOL) * 10000

    this.entity.ID = ID
    this.entity.tabNum = record.TAB
    this.entity.employeeID = ID
    this.entity.taxCode = record.IKOD ? record.IKOD : ''
    this.entity.employeeNumberID = ID

    this.entity.organizationID = record.BOL
    this.entity.departmentID = this.dictionary.getDepartmentID(record.BOL)
    this.entity.dictPositionID = this.dictionary.getDictPositionIDbyPath(record.B_DOL, path.dirname(this.sourceFullFileName)) || ''
    this.entity.dateFrom = record.DATPOST ? dateFormat(record.DATPOST) : ''
    this.entity.dateTo = record.DATZ ? dateFormat(record.DATZ) : '9999-12-31'
    this.entity.mtCount = 1 // record.VKLSTAV

    this.entity.workPlace = Number(this.entity.tabNum) > 8000 ? '2' : '1'
    this.entity.workerType = '1'
    this.entity.workScheduleID = record.REGIM || ''

    const fullName = this.dictionary.getEmployeeFullName(this.entity.employeeID)
    const positionName = this.dictionary.getDictPositionNamebyPath(record.B_DOL, path.dirname(this.sourceFullFileName)) || ''
    this.entity.description = `${this.entity.tabNum} ${fullName} ${positionName}`
    this.entity.dictStaffCatID = this.dictionary.getDictStaffCatIDbyPath(record.KAT, path.dirname(this.sourceFullFileName)) || ''
    this.entity.dictFundSourceID = record.FOND ? record.FOND : ''
    this.entity.dictCategoryECBID = record.INVALID ? ECB2 : ECB1

    if (record.S00) {
        this.entity.payElID = PAYEL146
        this.entity.accrualSum = record.S00
    } else if (record.S01) {
        this.entity.payElID = PAYEL147
        this.entity.accrualSum = record.S01
    } else if (record.S03) {
        this.entity.payElID = PAYEL246
        this.entity.accrualSum = record.S03
    } else if (record.S04) {
        this.entity.payElID = PAYEL247
        this.entity.accrualSum = record.S04
    } else if (record.S05) {
        this.entity.payElID = PAYEL248
        this.entity.accrualSum = record.S05
    } else {
        this.entity.payElID = PAYEL146
        this.entity.accrualSum = 0
    }

    this.appointmentDate = this.entity.dateFrom
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
