'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const dateFormat = require('../helper/dateFormat')
// const makePositionID = require('../helper/makePositionID')
const { PAYEL001, PAYEL002, PAYEL003, PAYEL025, PAYEL146, PAYEL147, PAYEL246, PAYEL247, PAYEL248, PAYEL249 } = require('./hr_payEl')
const { ECB1, ECB2 } = require('./hr_dictCategoryECB')
const path = require('path')

const Entity = require('../entity/EmployeePosition')
const TARGET_FILE_NAME = 'Призначення працівників (hr_employeePosition).csv'

function setRecord (record, recordNumber) {
    if (this.mapper) this.mapper(record)
    if (this.filter && !this.filter(record)) return false
    const ID = Number(record.TAB) + Number(record.BOL) * 10000 * Math.pow(100, record.UWOL || 0)

    this.entity.ID = ID
    this.entity.tabNum = record.TAB
    this.entity.employeeID = ID
    this.entity.taxCode = record.IKOD ? record.IKOD : ''
    this.entity.employeeNumberID = ID

    this.entity.orgID = record.BOL
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
    this.entity.dictFundSourceID = record.FOND || ''
    this.entity.dictCategoryECBID = record.INVALID ? ECB2 : ECB1
    const dictProgClass = this.dictionary.getDictProgClass(record.KPK)
    this.entity.dictProgClassID = dictProgClass ? dictProgClass.ID : ''

    this.dictionary.setDictProgClassID(ID, this.entity.dictProgClassID)
    this.dictionary.setDictFundSourceID(ID, this.entity.dictFundSourceID)

    if (record.S00) {
        this.entity.payElID = getPayEl(record) || PAYEL146
        this.entity.accrualSum = record.S00
    } else if (record.S01) {
        this.entity.payElID = getPayEl(record) || PAYEL147
        this.entity.accrualSum = record.S01
    } else if (record.S03) {
        this.entity.payElID = getPayEl(record) || PAYEL246
        this.entity.accrualSum = record.S03
    } else if (record.S04) {
        this.entity.payElID = getPayEl(record) || PAYEL247
        this.entity.accrualSum = record.S04
    } else if (record.S05) {
        this.entity.payElID = getPayEl(record) || PAYEL248
        this.entity.accrualSum = record.S05
    } else if (record.S06) {
        this.entity.payElID = getPayEl(record) || PAYEL247
        this.entity.accrualSum = record.S06
    } else if (record.S07) {
        this.entity.payElID = getPayEl(record) || PAYEL247
        this.entity.accrualSum = record.S07
    } else if (record.S08) {
        this.entity.payElID = getPayEl(record) || PAYEL247
        this.entity.accrualSum = record.S08
    } else {
        this.entity.payElID = getPayEl(record) || PAYEL146
        this.entity.accrualSum = 0
    }

    this.entity.appointmentDate = this.entity.dateFrom
    this.orderNumber = record.NAKP || ''
    this.orderDate = record.DATP ? dateFormat(record.DATP) : ''

    const dictTarif = this.dictionary.getDictTarifCoeffIDbyName(record.FAM, record.IM, record.OT)
    if (dictTarif && dictTarif.dictTarifCoeffID) {
        this.entity.dictTarifCoeffID = dictTarif.dictTarifCoeffID
    }
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
    target.filter = config.filter
    target.mapper = config.mapper
    return makeFile(target)
}

function getPayEl (record) {
    let VOPL = record.VOPL || 1
    if (VOPL > 2) { VOPL = 1 }

    if (VOPL === 1 && record.VS === 26) {
        return PAYEL003
    }
    // ознака держслужбовця (1 - так)
    if (record.PR_GA) {
        return PAYEL025
    }
    if (VOPL === 1) {
        return PAYEL001
    }
    if (VOPL === 2) {
        return PAYEL002
    }
    // ознака спецстажу (1 - педпацівник)
    if (record.SPECST === 1) {
        return PAYEL146
    }
    // ознака спецстажу (2 - медпрацівник)
    if (record.SPECST === 2) {
        return PAYEL249
    }
    return null
}

module.exports = makeTarget
