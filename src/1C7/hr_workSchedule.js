'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')

// Be attentive to fill this section
const Entity = require('../entity/SimpleEntity')
const SOURCE_FILE_NAME = 'GRF.DBF'
const TARGET_FILE_NAME = 'Графіки роботи (hr_workSchedule).csv'

function setRecord(record, recordNumber) {
    this.entity.ID = recordNumber
    this.entity.code = record.CD
    this.entity.name = record.NM
    this.entity.description = `${this.entity.name} (${this.entity.code})`
    this.dictionary.setWorkScheduleID(this.entity.code, this.entity.ID)
    return true
}

function makeTarget(config, dictionary) {
    let target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = getFullFileName(config.c1DbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

module.exports = makeTarget

