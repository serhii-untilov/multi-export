'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const path = require('path')

const Entity = require('../entity/PayOut')
const TARGET_FILE_NAME = 'Шаблони виплати (hr_payOut).csv'

function setRecord(record, recordNumber) {
    if (this.mapper) this.mapper(record)
    if (this.filter && !this.filter(record)) return false
    if (!record.STEPEN1) {
        return false
    }
    this.entity.ID = Number(record.STEPEN1) + Number(record.BOL) * 10000
    this.entity.code = record.STEPEN1
    const payOut = this.dictionary.getPayOut(
        this.entity.code,
        path.dirname(this.sourceFullFileName)
    )
    // this.entity.ID = payOut.ID
    if (this.dictionary.getPayOutID(this.entity.ID)) {
        return false
    }
    this.entity.name = payOut.name + ' (' + record.BOL + ')'
    this.entity.description = this.entity.name
    this.dictionary.setPayOutID(this.entity.ID, this.entity.ID)
    this.entity.orgID = record.BOL
    return true
}

function makeTarget(config, dictionary, sourceFile, index) {
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

module.exports = makeTarget
