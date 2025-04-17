'use strict'

const getFullFileName = require('../helper/getFullFileName')
const { Target } = require('../Target')
const makeFile = require('./TargetOsvita')

const Entity = require('../entity/TaxLimit')
const TARGET_FILE_NAME = 'Пільги ПДФО (hr_taxLimit).csv'

function setRecord(record, recordNumber) {
    this.entity.ID = record.KOD
    this.entity.code = record.KOD
    if (this.dictionary.getTaxLimitID(this.entity.code)) {
        return false
    }
    this.entity.name = record.NAIM
    this.entity.size = record.PROCPIL ? record.PROCPIL / 100 : ''
    this.entity.taxLimitType = record.PRIZDET ? (record.PRIZDET === 1 ? 2 : 1) : ''
    this.dictionary.setTaxLimitID(this.entity.code, this.entity.ID)
    return true
}

async function makeTarget(config, dictionary, sourceFullFileName, index) {
    const target = new Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = sourceFullFileName
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    target.append = index > 0
    return await makeFile(target)
}

module.exports = makeTarget
