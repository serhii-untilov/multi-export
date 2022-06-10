'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')

const Entity = require('../entity/SimpleEntity')
const TARGET_FILE_NAME = 'Довідник КПК (ac_dictProgClass).csv'

function setRecord (record, recordNumber) {
    this.entity.code = '' + record.KPK
    if (!this.entity.code.length) { return false }
    if (this.dictionary.getDictProgClass(this.entity.code)) { return false }
    this.entity.ID = this.dictionary.getNextDictProgClassID(this.entity.code)
    this.entity.name = '' + record.KPK
    this.entity.description = `${this.entity.name} (${this.entity.code})`
    this.dictionary.setDictProgClass(this.entity.code, this.entity.ID)
    return true
}

function makeTarget (config, dictionary, sourceFullFileName, index) {
    const target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = sourceFullFileName
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    target.append = index > 0
    return makeFile(target)
}

module.exports = makeTarget
