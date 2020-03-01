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
    this.ID = 0
    this.code = record.DOL
    this.name = ''
    this.description = `${entity.name} (${entity.code})`
}

function makeTarget(config, dictionary) {
    let target = new Target.Target()
    target.fullFileName = fullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = fullFileName(config.c1DbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.entity.setRecord = setRecord
    return makeFile(target)
}

module.exports = makeTarget
