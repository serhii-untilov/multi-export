'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')

const Entity = require('../entity/SimpleEntity')
const SOURCE_FILE_NAME = 'KATEGOR.DBF'
const TARGET_FILE_NAME = 'Категорії персоналу (hr_dictStaffCat).csv'

function setRecord (record, recordNumber) {
    this.entity.ID = record.KOD
    this.entity.code = record.KOD
    this.entity.name = record.KATEGOR
    this.entity.description = `${this.entity.name} (${this.entity.code})`
    this.dictionary.setDictPositionName(this.entity.ID, this.entity.name)
    return true
}

function makeTarget (config, dictionary) {
    const target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = getFullFileName(config.osvitaDbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

module.exports = makeTarget
