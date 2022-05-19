'use strict'

const Target = require('../Target')
const makeFile = require('./TargetOsvita')

const Entity = require('../entity/Organization')
// const TARGET_FILE_NAME = 'Організація (hr_organization).csv'

function setRecord (record, recordNumber) {
    this.entity.ID = Number(this.sourceFullFileName.replace(/(.*DO0*)([0-9]*)(\.DBF)/i, '$2'))
    if (this.dictionary.getOrganization(this.entity.ID)) { return false }
    this.entity.code = '' + this.entity.ID
    this.entity.name = record.NUCH1
    this.entity.EDRPOUCode = record.ZKPO
    this.dictionary.setOrganization(this.entity.ID, this.entity.code, this.entity.name, this.entity.EDRPOUCode)
    return false
}

function makeTarget (config, dictionary, sourceFile, index) {
    const target = new Target.Target()
    target.fullFileName = null
    target.sourceFullFileName = sourceFile
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    target.append = index > 0
    return makeFile(target)
}

module.exports = makeTarget
