'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')

const Entity = require('../entity/PayOut')
const TARGET_FILE_NAME = 'Шаблони виплати (hr_payOut).csv'

function setRecord (record, recordNumber) {
    if (!record.STEPEN1) { return false }
    this.entity.ID = record.STEPEN1
    this.entity.code = record.STEPEN1
    if (this.dictionary.getPayOutID(this.entity.code)) { return false }
    this.entity.name = record.STEPEN1
    this.entity.description = this.entity.name + ' (' + this.entity.code + ')'
    this.dictionary.setPayOutID(this.entity.code, this.entity.ID)
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
