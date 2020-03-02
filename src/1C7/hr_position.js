'use strict'

const fullFileName = require('../helper/fullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')

// Be attentive to fill this section
const Entity = require('../entity/Position') 
const SOURCE_FILE_NAME = 'PRK.DBF'
const TARGET_FILE_NAME = 'Посади (штатні позиції) (hr_position).csv'

function setRecord(record, recordNumber) {
    // TODO: Need to fill all the fields and join the same positions using the Dictionary class.
    this.entity.ID = 0
    this.entity.code = record.DOL
    this.entity.name = ''
    this.entity.description = `${this.entity.name} (${this.entity.code})`
}

function makeTarget(config, dictionary) {
    let target = new Target.Target()
    target.fullFileName = fullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = fullFileName(config.c1DbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

module.exports = makeTarget
