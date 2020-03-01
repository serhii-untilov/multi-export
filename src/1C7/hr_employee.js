'use strict'

const fullFileName = require('../helper/fullFileName')
const Target = require('../Target')
const makeFile = require('./Target1C7')

// Be attentive to fill this section
const Entity = require('../entity/Employee')
const SOURCE_FILE_NAME = 'LS.DBF'
const TARGET_FILE_NAME = 'Працівники (hr_employee).csv'

function setRecord(record, recordNumber) {
    this.ID = record['TN'] // record['ID']
    this.name = record['FIO'].split(' ')
    this.lastName = name[0]
    this.firstName = name[1]
    this.middleName = name[2]
    this.shortFIO = name[0] + ' ' + name[1][0] + '.' + name[2][0] + '.' 
    this.fullFIO = record['FIO']
    this.genName = record['FIOR']
    this.datName = record['FIOD']
    this.tabNum = record['TN']
    this.sexType = record['SEX'] == 1 ? 'M' : record['SEX'] == 2 ? 'W' : ''
    this.birthDate = dateFormat(record['DTROJ'])
    this.taxCode = record['NLP']
    this.email = record['EMAIL']
    this.description = record['FIO'] + ' (' + str(record['TN']) + ')'
    this.locName = record['FIO']
    this.dayBirthDate = record['DTROJ'] ? record['DTROJ'].day : ''
    this.monthBirthDate = record['DTROJ'] ? record['DTROJ'].month : ''
    this.yearBirthDate = record['DTROJ'] ? record['DTROJ'].year : ''
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
