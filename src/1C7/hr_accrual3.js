'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')
const dateFormat = require('../helper/dateFormat')

// Be attentive to fill this section
const Entity = require('../entity/Accrual') 
const SOURCE_FILE_NAME = 'RL_Lik_F.DBF'
const TARGET_FILE_NAME = 'Розрахункові листи працівників (hr_accrual).csv'

function setRecord(record, recordNumber) {
    this.entity.ID = this.dictionary.getCommonID()
    this.entity.periodCalc = dateFormat(record.UP)
    this.entity.periodSalary = dateFormat(record.RP)
    this.entity.tabNum = record.TN
    this.entity.taxCode = this.dictionary.getTaxCode(this.tabNum)
    this.entity.employeeNumberID = this.entity.tabNum
    this.entity.payElID = this.dictionary.getPayElID(record.CD)
    this.entity.paySum = record.SM ? record.SM : ''
    this.entity.days = record.DAYS ? record.DAYS : ''
    this.entity.hours = record.HRS ? record.HRS : ''
    this.entity.calculateDate = ''	
    this.entity.flagsRec = 8 | (record.STOR > 0 ? 512 : 0) // 8 - import, 512 - storno
    this.entity.dateFrom = dateFormat(record.PR_BEG)
    this.entity.dateTo = dateFormat(record.PR_END)
    return true
}

function makeTarget(config, dictionary) {
    let target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = getFullFileName(config.c1DbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    target.append = true
    return makeFile(target)
}

module.exports = makeTarget
