'use strict'

const getFullFileName = require('../helper/getFullFileName')
const { Target } = require('../Target')
const makeFile = require('./TargetOsvita')
const path = require('path')

const Entity = require('../entity/SimpleEntity')
const TARGET_FILE_NAME = 'Категорії персоналу (hr_dictStaffCat).csv'

function setRecord(record, recordNumber) {
    this.entity.code = record.KOD
    this.entity.ID = this.dictionary.getDictStaffCatIDbyPath(
        this.entity.code,
        path.dirname(this.sourceFullFileName)
    )
    if (this.entity.ID) {
        return false
    }
    this.entity.name = record.KATEGOR
    this.entity.description = `${this.entity.name} (${this.entity.code})`
    const exists = this.dictionary.setDictStaffCatIDbyPath(
        this.entity.code,
        this.entity.name,
        path.dirname(this.sourceFullFileName)
    )
    if (exists) {
        return false
    }
    this.entity.ID = this.dictionary.getDictStaffCatIDbyPath(
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
