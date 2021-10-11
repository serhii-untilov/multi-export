'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')

const Entity = require('../entity/Employee')
const TARGET_FILE_NAME = 'Працівники (hr_employee).csv'

function setRecord (record, recordNumber) {
    const ID = Number(record.TAB) + Number(record.BOL) * 10000
    this.entity.ID = ID
    this.entity.organizationID = record.BOL
    this.entity.lastName = record.FAM
    this.entity.firstName = record.IM
    this.entity.middleName = record.OT
    this.entity.shortFIO = record.FAM + ' ' + record.IM[0] + '.' + record.OT[0] + '.'
    this.entity.fullFIO = record.FAM + ' ' + record.IM + ' ' + record.OT
    this.entity.tabNum = record.TAB
    this.entity.sexType = record.KAT === 2 ? 'M' : record.SEX === 1 ? 'W' : ''
    this.entity.taxCode = record.IKOD
    this.entity.description = this.entity.fullFIO + ' (' + record.TAB + ')'
    this.entity.locName = this.entity.fullFIO
    this.dictionary.setEmployeeFullName(this.entity.ID, this.entity.fullFIO)
    return true
}

function makeTarget (config, dictionary, sourceFile, index) {
    const target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = sourceFile
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    target.append = index > 0
    return makeFile(target)
}

module.exports = makeTarget
