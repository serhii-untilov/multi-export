'use strict'

const fullFileName = require('../helper/fullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')

// Be attentive to fill this section
const Entity = require('../entity/SimpleEntity')
const SOURCE_FILE_NAME = 'DOL.DBF'
const TARGET_FILE_NAME = 'Довідник посад (не штатних позицій) (hr_dictPosition).csv'

function setRecord(record, recordNumber) {
    this.entity.ID = record.CD
    this.entity.code = record.CD
    this.entity.name = record.NM
    this.entity.description = `${this.entity.name} (${this.entity.code})`
    this.dictionary.setDictPositionName(this.entity.ID, this.entity.name)
    return true
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
