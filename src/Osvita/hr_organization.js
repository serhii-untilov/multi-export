'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')

const Entity = require('../entity/Organization')
const TARGET_FILE_NAME = 'Організація (hr_organization).csv'

function setRecord (record, recordNumber) {
    const orgID = this.sourceFullFileName.replace(/(.*DO0*)([0-9]*)(\.DBF)/i, '$2')
    this.entity.ID = orgID
    this.entity.code = '' + orgID
    if (this.dictionary.getOrganizationID(this.entity.code)) { return false }
    this.entity.EDRPOUCode = record.ZKPO
    this.entity.name = this.entity.code + ' ' + record.NUCH1
    this.entity.fullName = this.entity.code + ' ' + record.NUCH1
    this.entity.description = this.entity.code + ' ' + record.NUCH1
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
    return makeFile(target)
}

module.exports = makeTarget
