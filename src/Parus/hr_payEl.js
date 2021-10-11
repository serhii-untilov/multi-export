'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetParus')

const Entity = require('../entity/PayEl')
const SOURCE_FILE_NAME = 'vobase.dbf'
const TARGET_FILE_NAME = 'Види оплати (hr_payEl).csv'

function setRecord (record, recordNumber) {
    if (!this.dictionary.isPayElUsed(record.ID)) { return false }
    this.entity.ID = recordNumber
    this.entity.code = record.VO
    this.entity.name = record.NAME
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
    return true
}

function makeTarget (config, dictionary) {
    const target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = getFullFileName(config.parusDbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

module.exports = makeTarget
