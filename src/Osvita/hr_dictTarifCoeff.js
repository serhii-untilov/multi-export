'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')

const Entity = require('../entity/SimpleEntity')
const TARGET_FILE_NAME = 'Тарифні розряди (hr_dictTarifCoeff).csv'

function setRecord (record) {
    this.entity.ID = record.id
    this.entity.code = record.code
    this.entity.name = record.name
    this.entity.description = `${this.entity.name} (${this.entity.code})`
    return true
}

function makeTarget (config, dictionary) {
    const target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

const makeFile = function (target) {
    return new Promise((resolve, reject) => {
        try {
            if (!target.append) { removeFile(target.fullFileName) }
            let buffer = target.append ? '' : target.entity.getHeader()
            const source = [
                { id: 1, code: '1', name: '1' },
                { id: 2, code: '2', name: '2' },
                { id: 3, code: '3', name: '3' },
                { id: 4, code: '4', name: '4' },
                { id: 5, code: '5', name: '5' },
                { id: 6, code: '6', name: '6' },
                { id: 7, code: '7', name: '7' },
                { id: 8, code: '8', name: '8' },
                { id: 9, code: '9', name: '9' },
                { id: 10, code: '10', name: '10' },
                { id: 11, code: '11', name: '11' },
                { id: 12, code: '12', name: '12' },
                { id: 13, code: '13', name: '13' },
                { id: 14, code: '14', name: '14' },
                { id: 15, code: '15', name: '15' },
                { id: 16, code: '16', name: '16' },
                { id: 17, code: '17', name: '17' },
                { id: 18, code: '18', name: '18' },
                { id: 19, code: '19', name: '19' },
                { id: 20, code: '20', name: '20' },
                { id: 21, code: '21', name: '21' },
                { id: 22, code: '22', name: '22' },
                { id: 23, code: '23', name: '23' },
                { id: 24, code: '24', name: '24' },
                { id: 25, code: '25', name: '25' }
            ]
            for (let i = 0; i < source.length; i++) {
                if (target.setRecord(source[i])) {
                    target.recordsCount++
                    buffer += target.entity.getRecord()
                    fs.appendFile(target.fullFileName, buffer, (err) => {
                        if (err) throw err
                    })
                    buffer = ''
                }
            }
            target.state = target.recordsCount ? Target.FILE_CREATED : Target.FILE_EMPTY
            resolve(target)
        } catch (err) {
            console.error(err)
            reject(err)
        }
    })
}

module.exports = makeTarget
