'use strict'

const fullFileName = require('../helper/fullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')

// Be attentive to fill this section
const Entity = require('../entity/Accrual') 
const SOURCE_FILE_NAME = 'RL.DBF'
const TARGET_FILE_NAME = 'Розрахункові листи працівників (hr_accrual).csv'

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
    this.periodCalc = dateFormat(record['UP'])
    this.periodSalary = dateFormat(record['RP'])
    this.tabNum = record['TN']
    this.taxCode = dictionary.get_TaxCode(this.tabNum)
    this.employeeNumberID = this.tabNum
    this.payElID = dictionary.get_PayElID(record['CD'])
    this.paySum = record['SM'] ? record['SM'] : ''
    this.days = record['DAYS'] ? record['DAYS'] : ''
    this.hours = record['HRS'] ? str(record['HRS']) : ''
    this.calculateDate = ''	
    this.flagsRec = 8 | (record['STOR'] > 0 ? 512 : 0) // 8 - import, 512 - storno
    this.dateFrom = dateFormat(record['PR_BEG'])
    this.dateTo = dateFormat(record['PR_END'])
}

module.exports = makeTarget
