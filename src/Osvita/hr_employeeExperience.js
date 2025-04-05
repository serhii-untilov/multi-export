'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const dateFormat = require('../helper/dateFormat')

const Entity = require('../entity/EmployeeExperience')
const TARGET_FILE_NAME = 'Стаж роботи працівників (hr_employeeExperience).csv'

function setRecord(record, recordNumber) {
    if (this.mapper) this.mapper(record)
    if (this.filter && !this.filter(record)) return false
    this.entity = []
    this.entity.push(new Entity())
    const ID = Number(record.TAB) + Number(record.BOL) * 10000 * Math.pow(100, record.UWOL || 0)
    this.entity[0].ID = this.dictionary.getEmployeeExperienceID()
    this.entity[0].employeeID = ID
    this.entity[0].employeeNumberID = ID
    const experience = this.dictionary.getExperienceByName(record.FAM, record.IM, record.OT)
    if (experience) {
        const baseDate = new Date(this.baseDate || '2021-10-01')
        baseDate.setFullYear(baseDate.getFullYear() - experience.years)
        baseDate.setMonth(baseDate.getMonth() - experience.months)
        baseDate.setDate(baseDate.getDate() - experience.days)
        this.entity[0].calcDate = dateFormat(baseDate)
        this.entity[0].dictExperienceID = this.entity[0].calcDate ? 5 : 0
    } else if (record.SPECST === 1) {
        // ознака спецстажу (1 - педпацівник)
        this.entity[0].dictExperienceID = 5
        this.entity[0].calcDate = record.DATPOST ? dateFormat(record.DATPOST) : ''
    } else if (record.SPECST === 2) {
        // ознака спецстажу (2 - медпрацівник)
        this.entity[0].dictExperienceID = 6
        this.entity[0].calcDate = record.DATPOST ? dateFormat(record.DATPOST) : ''
    } else if (record.PR_GA) {
        // ознака держслужбовця (1 - так)
        this.entity[0].dictExperienceID = 4
        this.entity[0].calcDate = record.DATPOST ? dateFormat(record.DATPOST) : ''
    }
    if (this.entity[0].dictExperienceID) {
        this.entity.push(new Entity())
        this.entity[1].ID = this.dictionary.getEmployeeExperienceID()
        this.entity[1].employeeID = ID
        this.entity[1].employeeNumberID = ID
        this.entity[1].dictExperienceID = 3 // Страховий
        this.entity[1].calcDate = this.entity[0].calcDate
        return true
    }
    return false
}

function makeTarget(config, dictionary, sourceFile, index) {
    const target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = sourceFile
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    target.append = index > 0
    target.baseDate = new Date(config.osvitaBaseDate || '2022-01-01')
    target.filter = config.filter
    target.mapper = config.mapper
    return makeFile(target)
}

module.exports = makeTarget
