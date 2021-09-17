'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')

// Be attentive to fill this section
const Entity = require('../entity/SimpleEntity')
const SOURCE_FILE_NAME = 'SPRA_DOL.DBF'
const TARGET_FILE_NAME = 'Довідник посад (не штатних позицій) (hr_dictPosition).csv'

function setRecord(record, recordNumber) {
    this.entity.ID = record.KOD
    this.entity.code = record.KOD
    this.entity.name = record.POCA || record.DOL
    this.entity.description = `${this.entity.name} (${this.entity.code})`
    this.dictionary.setDictPositionName(this.entity.ID, this.entity.name)
    return true
}

function makeTarget(config, dictionary) {
    let target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = getFullFileName(config.osvitaDbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

module.exports = makeTarget
