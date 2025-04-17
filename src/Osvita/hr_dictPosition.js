'use strict'

const getFullFileName = require('../helper/getFullFileName')
const { Target } = require('../Target')
const makeFile = require('./TargetOsvita')
const path = require('path')

const Entity = require('../entity/SimpleEntity')
const TARGET_FILE_NAME = 'Довідник посад (не штатних позицій) (hr_dictPosition).csv'

function setRecord(record, recordNumber) {
    this.entity.code = record.KOD
    this.entity.ID = this.dictionary.getDictPositionIDbyPath(
        this.entity.code,
        path.dirname(this.sourceFullFileName)
    )
    if (this.entity.ID) {
        return false
    }
    this.entity.name = record.POCA || record.DOL
    this.entity.description = `${this.entity.name} (${this.entity.code})`
    const exists = this.dictionary.setDictPositionIDbyPath(
        this.entity.code,
        this.entity.name,
        path.dirname(this.sourceFullFileName)
    )
    if (exists) {
        return false
    }
    this.entity.ID = this.dictionary.getDictPositionIDbyPath(
        this.entity.code,
        path.dirname(this.sourceFullFileName)
    )
    return true
}

function makeTarget(config, dictionary, sourceFullFileName, index) {
    const target = new Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = sourceFullFileName
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    target.append = index > 0
    return makeFile(target)
}

module.exports = makeTarget
