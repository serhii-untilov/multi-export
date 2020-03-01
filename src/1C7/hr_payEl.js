'use strict'

const fullFileName = require('../helper/fullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')

// Be attentive to fill this section
const Entity = require('../entity/PayEl')
const SOURCE_FILE_NAME = 'VO.DBF'
const TARGET_FILE_NAME = 'Види оплати (hr_payEl).csv'

function setRecord(record, recordNumber) {
    this.ID = recordNumber
    this.code = record.CD
    this.name = record.NM
    this.methodID = ''
    this.description = `${entity.name} (${entity.code})`
    this.dateFrom = ''
    this.dateTo = ''
    this.roundUpTo = '2'
    this.isAutoCalc = '1'
    this.isRecalculate = '1'
    this.calcProportion = ''
    this.calcSumType = ''
    this.periodType = ''
    this.dictExperienceID = ''
    this.calcMounth = ''
    this.averageMethod = ''
    this.typePrepayment = ''
    this.prepaymentDay = ''
    this.dictFundSourceID = ''
    this.setPayElID(this.entity.code, this.entity.ID)
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