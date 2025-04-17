'use strict'

const getFullFileName = require('../helper/getFullFileName')
const { Target } = require('../Target')
const makeFile = require('./TargetOsvita')

const Entity = require('../entity/Addresses')
const TARGET_FILE_NAME = 'Адреси працівників (ac_address).csv'

function setRecord(record, recordNumber) {
    if (this.mapper) this.mapper(record)
    if (this.filter && !this.filter(record)) return false
    const ID = Number(record.TAB) + Number(record.BOL) * 10000 * Math.pow(100, record.UWOL || 0)
    this.entity.ID = ID
    this.entity.orgID = record.BOL
    this.entity.ownerID = ID

    this.entity.addressType = '1'
    this.entity.postIndex = ''
    this.entity.address =
        record.ADRG +
        (record.ADRG && record.ADRR ? ', ' : '') +
        record.ADRR +
        ((record.ADRG || record.ADRR) && record.ADRO ? ', ' : '') +
        record.ADRO
    this.entity.countryID = 804

    return !!this.entity.address
}

function makeTarget(config, dictionary, sourceFile, index) {
    const target = new Target()
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
