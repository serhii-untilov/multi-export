'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')
const dateFormat = require('../helper/dateFormat')

// Be attentive to fill this section
const Entity = require('../entity/TaxLimit') 
const SOURCE_FILE_NAME = 'SPLG.DBF'
const TARGET_FILE_NAME = 'Пільги ПДФО (hr_taxLimit).csv'

function setRecord(record, recordNumber) {
    if (!this.dictionary.isTaxLimitUsed(record.CD)) 
        return false
    this.entity.ID = recordNumber
    this.entity.code = record.CD
    this.entity.name = record.NM
    this.entity.size = record.KILDIT
    this.dictionary.setTaxLimitID(this.entity.code, this.entity.ID)
    return true
}

function makeTarget(config, dictionary) {
    let target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = getFullFileName(config.c1DbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

module.exports = makeTarget
