'use strict'

const fullFileName = require('../helper/fullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')

// Be attentive to fill this section
const Entity = require('../entity/EmployeeNumber')
const SOURCE_FILE_NAME = 'LS.DBF'
const TARGET_FILE_NAME = 'Особові рахунки працівників (hr_employeeNumber).csv'

function setRecord(record, recordNumber) {
    this.ID = record['TN'] // record['ID']
    this.employeeID = record['TN']
    this.taxCode = record['NLP']
    this.tabNum = record['TN']
    this.dateFrom = record['BEG'] ? dateFormat(record['BEG']) : ''
    this.dateTo = record['END'] ? dateFormat(record['END']) : ''
    this.description = record['FIO'] + ' (' + str(record['TN']) + ')'
    this.payOutID = ''
    this.personalAccount = record['BANKRAH']
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
