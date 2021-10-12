'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')

const Entity = require('../entity/Addresses')
const TARGET_FILE_NAME = 'Адреси працівників (ac_address).csv'

function setRecord (record, recordNumber) {
    const ID = Number(record.TAB) + Number(record.BOL) * 10000
    this.entity.ID = ID
    this.entity.orgID = record.BOL
    this.entity.ownerID = ID

    this.entity.addressType = '1'
    this.entity.postIndex = ''
    this.entity.address = record.ADRG +
        ((record.ADRG && record.ADRR) ? ', ' : '') +
        record.ADRR +
        ((record.ADRG || record.ADRR) && record.ADRO ? ', ' : '') +
        record.ADRO

    return !!(this.entity.address)
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
