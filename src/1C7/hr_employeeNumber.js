'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')
const dateFormat = require('../helper/dateFormat')

const Entity = require('../entity/EmployeeNumber')
const SOURCE_FILE_NAME = 'LS.DBF'
const TARGET_FILE_NAME = 'Особові рахунки працівників (hr_employeeNumber).csv'

function setRecord(record, recordNumber) {
    this.entity.ID = record.TN // record.ID
    this.entity.employeeID = record.TN
    this.entity.taxCode = record.NLP
    this.entity.tabNum = record.TN
    this.entity.dateFrom = record.BEG ? dateFormat(record.BEG) : ''
    this.entity.dateTo = record.END ? dateFormat(record.END) : ''
    this.entity.description = record.FIO + ' (' + record.TN + ')'
    this.entity.payOutID = ''
    this.entity.personalAccount = record.BANKRAH
    this.dictionary.setTaxCode(record.TN, record.NLP)
    return true
}

function makeTarget(config, dictionary) {
    const target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = getFullFileName(config.c1DbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

module.exports = makeTarget
