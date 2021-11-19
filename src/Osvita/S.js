'use strict'

const Target = require('../Target')
const makeFile = require('./TargetOsvita')

const Entity = require('../entity/SimpleEntity')

function setRecord (record, recordNumber) {
    if (record.RAZTAR) {
        this.dictionary.setDictTarifCoeffIDbyName(record.FAM, record.IM, record.OT, record.RAZTAR)
    }
    if (record.OBRAZ) {
        const dictEducationLevelID = getEducationLevelID(record.OBRAZ)
        if (dictEducationLevelID) {
            this.dictionary.setDictEducationLevelIDbyName(record.FAM, record.IM, record.OT, dictEducationLevelID)
        }
    }
    return false
}

function makeTarget (config, dictionary, sourceFullFileName, index) {
    const target = new Target.Target()
    target.fullFileName = null
    target.sourceFullFileName = sourceFullFileName
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    target.append = index > 0
    return makeFile(target)
}

function getEducationLevelID (OBRAZ) {
    switch (OBRAZ) {
    case 'Вища': return 7
    case 'Спец': return 3
    case 'Н/вища': return 5
    case 'Серед': return 2
    default: return null
    }
}

module.exports = makeTarget
