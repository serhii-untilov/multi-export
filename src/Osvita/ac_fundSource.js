'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')

// Be attentive to fill this section
const Entity = require('../entity/FundSource') 
const TARGET_FILE_NAME = 'Джерело фінансування (ac_fundSource).csv'

function setRecord(record, recordNumber) {
    if (!record.FOND) { return false }
    this.entity.ID = record.FOND
    this.entity.code = record.FOND
    if (this.dictionary.getFundSourceID(this.entity.code)) { return false }
    this.entity.name = record.FOND
    this.entity.description = this.entity.name + ' (' + this.entity.code + ')'
    this.dictionary.setFundSourceID(this.entity.code, this.entity.ID)
    return true
}

function makeTarget(config, dictionary, sourceFile, index) {
    let target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = sourceFile
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    target.append = index > 0
    return makeFile(target)
}

module.exports = makeTarget
