'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const path = require('path')

const Entity = require('../entity/SimpleEntity')
const TARGET_FILE_NAME = null

function setRecord (record, recordNumber) {
    this.entity.code = record.K_B
    this.entity.name = record.NA
    if (this.dictionary.getPayOut(this.entity.code, path.dirname(this.sourceFullFileName))) { return false }
    this.dictionary.setPayOut(this.dictionary.getCommonID(), this.entity.code, this.entity.name, path.dirname(this.sourceFullFileName))
    return false
}

function makeTarget (config, dictionary, sourceFullFileName, index) {
    const target = new Target.Target()
    target.fullFileName = null
    target.sourceFullFileName = sourceFullFileName
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    target.append = index > 0
    return makeFile(target)
}

module.exports = makeTarget
