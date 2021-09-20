'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')

const Entity = require('../entity/TaxLimit')
const SOURCE_FILE_NAME = 'SOCPIL.DBF'
const TARGET_FILE_NAME = 'Пільги ПДФО (hr_taxLimit).csv'

function setRecord (record, recordNumber) {
    this.entity.ID = record.KOD
    this.entity.code = record.KOD
    this.entity.name = record.NAIM
    this.entity.size = record.PROCPIL ? record.PROCPIL / 100 : ''
    this.entity.taxLimitType = record.PRIZDET ? record.PRIZDET === 1 ? 2 : 1 : ''
    this.dictionary.setTaxLimitID(this.entity.code, this.entity.ID)
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
