'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')
const makePositionID = require('../helper/makePositionID')

// Be attentive to fill this section
const Entity = require('../entity/Position') 
const SOURCE_FILE_NAME = 'PRK.DBF'
const TARGET_FILE_NAME = 'Посади (штатні позиції) (hr_position).csv'

function setRecord(record, recordNumber) {
    // Join the same positions using the Dictionary class.
    let departmentID = this.dictionary.getDepartmentID(record.PDR)
    if (!departmentID || !record.DOL)
        return false
    let positionID = makePositionID(departmentID, record.DOL)
    if (this.dictionary.getPositionID(positionID))
        return false // already present
    this.entity.ID = positionID
    this.entity.code = record.DOL
    this.entity.name = this.dictionary.getDictPositionName(record.DOL)
    this.entity.description = `${this.entity.name} (${this.entity.code})`
    this.entity.fullName = this.entity.name
    this.entity.parentUnitID = departmentID

    this.dictionary.setPositionID(this.entity.ID) // for check presence
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
