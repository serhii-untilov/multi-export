'use strict'

const fullFileName = require('../helper/fullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')

// Be attentive to fill this section
const Entity = require('../entity/PayEl')
const SOURCE_FILE_NAME = 'VO.DBF'
const TARGET_FILE_NAME = 'Види оплати (hr_payEl).csv'

function setRecord(record, recordNumber) {
    this.entity.ID = recordNumber
    this.entity.code = record.ID
    this.entity.name = record.NM
    this.entity.methodID = ''
    this.entity.description = `${this.entity.name} (${this.entity.code})`
    this.entity.dateFrom = ''
    this.entity.dateTo = ''
    this.entity.roundUpTo = '2'
    this.entity.isAutoCalc = '1'
    this.entity.isRecalculate = '1'
    this.entity.calcProportion = ''
    this.entity.calcSumType = ''
    this.entity.periodType = ''
    this.entity.dictExperienceID = ''
    this.entity.calcMounth = ''
    this.entity.averageMethod = ''
    this.entity.typePrepayment = ''
    this.entity.prepaymentDay = ''
    this.entity.dictFundSourceID = ''
    this.dictionary.setPayElID(this.entity.code, this.entity.ID)
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