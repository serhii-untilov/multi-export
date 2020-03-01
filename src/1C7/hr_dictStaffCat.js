'use strict'

const fullFileName = require('../helper/fullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')

// Be attentive to fill this section
const Entity = require('../entity/SimpleEntity')
const SOURCE_FILE_NAME = 'KAT.DBF'
const TARGET_FILE_NAME = 'Категорії персоналу (hr_dictStaffCat).csv'

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
    this.ID = record.CD
    this.code = record.CD
    this.name = record.NM
    this.description = `${entity.name} (${entity.code})`
}

module.exports = makeTarget
