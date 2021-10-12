'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const dateFormat = require('../helper/dateFormat')

const Entity = require('../entity/EmployeeExperience')
const TARGET_FILE_NAME = 'Стаж роботи працівників (hr_employeeExperience).csv'

function setRecord (record, recordNumber) {
    const ID = Number(record.TAB) + Number(record.BOL) * 10000
    this.entity.ID = ID
    this.entity.employeeID = ID
    this.entity.employeeNumberID = ID

    if (record.SPECST === 1) {
        // ознака спецстажу (1 - педпацівник)
        this.entity.dictExperienceID = 5
        this.entity.calcDate = record.DATPOST ? dateFormat(record.DATPOST) : ''
    } else if (record.SPECST === 2) {
        // ознака спецстажу (2 - медпрацівник)
        this.entity.dictExperienceID = 6
        this.entity.calcDate = record.DATPOST ? dateFormat(record.DATPOST) : ''
    } else if (record.PR_GA) {
        // ознака держслужбовця (1 - так)
        this.entity.dictExperienceID = 4
        this.entity.calcDate = record.DATPOST ? dateFormat(record.DATPOST) : ''
    }

    return !!(this.entity.dictExperienceID)
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
