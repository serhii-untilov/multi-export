'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')

const Entity = require('../entity/Organization')
const TARGET_FILE_NAME = 'Організація (hr_organization).csv'

function setRecord (record, recordNumber) {
    if (record.DATZ && record.DATZ < this.baseDate) { return false }
    this.entity.ID = record.BOL
    this.entity.code = '' + record.BOL
    if (this.dictionary.getOrganizationID(this.entity.code)) { return false }
    const organization = this.dictionary.getOrganization(this.entity.ID)
    if (organization) {
        this.entity.code = organization.code
        this.entity.name = organization.code + ' ' + organization.name
        this.entity.EDRPOUCode = organization.edrpou
    } else {
        this.entity.name = this.entity.code
    }
    this.entity.fullName = this.entity.name
    this.entity.description = this.entity.name
    this.dictionary.setOrganizationID(this.entity.code, this.entity.ID)
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
    target.baseDate = new Date(config.osvitaBaseDate || '2022-01-01')
    return makeFile(target)
}

module.exports = makeTarget
