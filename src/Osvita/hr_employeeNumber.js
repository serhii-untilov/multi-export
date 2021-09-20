'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const dateFormat = require('../helper/dateFormat')

const Entity = require('../entity/EmployeeNumber')
const TARGET_FILE_NAME = 'Особові рахунки працівників (hr_employeeNumber).csv'

function setRecord (record, recordNumber) {
    const ID = Number(record.TAB) + Number(record.BOL) * 10000
    this.entity.ID = ID
    this.entity.employeeID = ID
    this.entity.orgID = record.BOL
    this.entity.taxCode = record.IKOD
    this.entity.tabNum = record.TAB
    this.entity.dateFrom = record.DATPOST ? dateFormat(record.DATPOST) : ''
    this.entity.dateTo = record.DATZ ? dateFormat(record.DATZ) : '9999-12-31'
    this.entity.description = record.FAM + ' ' + record.IM + ' ' + record.OT + ' (' + record.TAB + ')'
    this.entity.payOutID = record.STEPEN1 ? record.STEPEN1 : ''
    this.entity.personalAccount = record.NLS_S
    this.dictionary.setTaxCode(ID, record.IKOD)
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
