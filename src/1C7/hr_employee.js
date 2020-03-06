'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')
const dateFormat = require('../helper/dateFormat')

// Be attentive to fill this section
const Entity = require('../entity/Employee')
const SOURCE_FILE_NAME = 'LS.DBF'
const TARGET_FILE_NAME = 'Працівники (hr_employee).csv'

function setRecord(record, recordNumber) {
    this.entity.ID = record['TN'] // record['ID']
    let name = record['FIO'].split(' ')
    this.entity.lastName = name[0]
    this.entity.firstName = name[1]
    this.entity.middleName = name[2]
    this.entity.shortFIO = name[0] + ' ' + name[1][0] + '.' + name[2][0] + '.' 
    this.entity.fullFIO = record['FIO']
    this.entity.genName = record['FIOR']
    this.entity.datName = record['FIOD']
    this.entity.tabNum = record['TN']
    this.entity.sexType = record['SEX'] == 1 ? 'M' : record['SEX'] == 2 ? 'W' : ''
    this.entity.birthDate = dateFormat(record['DTROJ'])
    this.entity.taxCode = record['NLP']
    this.entity.email = record['EMAIL']
    this.entity.description = record['FIO'] + ' (' + record['TN'] + ')'
    this.entity.locName = record['FIO']
    this.entity.dayBirthDate = record['DTROJ'] ? record['DTROJ'].day : ''
    this.entity.monthBirthDate = record['DTROJ'] ? record['DTROJ'].month : ''
    this.entity.yearBirthDate = record['DTROJ'] ? record['DTROJ'].year : ''
    this.dictionary.setEmployeeFullName(this.entity.ID, this.entity.fullFIO)
    return true
}

function makeTarget(config, dictionary) {
    let target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourcegetFullFileName = getFullFileName(config.c1DbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

module.exports = makeTarget
