'use strict'

const Target = require('../Target')
const makeFile = require('./TargetOsvita')

const Entity = require('../entity/SimpleEntity')

function setRecord (record, recordNumber) {
    if (record.RAZTAR) {
        this.dictionary.setEmployeeByName(record.FAM, record.IM, record.OT, record.RAZTAR)
    }
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
