'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const getFullFileName = require('../helper/getFullFileName')
const { Target, Result } = require('../Target')

const Entity = require('../entity/SimpleEntity')
const TARGET_FILE_NAME = 'Довідник Стажі роботи (hr_dictExperience).csv'

function setRecord(record) {
    this.entity.ID = record.id
    this.entity.code = record.code
    this.entity.name = record.name
    this.entity.description = `${this.entity.name} (${this.entity.code})`
    return true
}

function makeTarget(config, dictionary) {
    const target = new Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

const makeFile = function (target) {
    return new Promise((resolve, reject) => {
        try {
            if (!target.append) {
                removeFile(target.fullFileName)
            }
            let buffer = target.append ? '' : target.entity.getHeader()
            const source = [
                { id: 1, code: '1', name: 'Загальний' },
                { id: 2, code: '2', name: 'На підприємстві' },
                { id: 3, code: '3', name: 'Страховий' },
                { id: 4, code: '4', name: 'Держслужба' },
                { id: 5, code: '5', name: 'Педагогічний' },
                { id: 6, code: '6', name: 'Медпрацівників' },
                { id: 7, code: '7', name: 'Спеціальний' },
                { id: 8, code: '8', name: 'Бібліотечний' }
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
            target.state = target.recordsCount ? Result.FILE_CREATED : Result.FILE_EMPTY
            resolve(target)
        } catch (err) {
            console.error(err)
            reject(err)
        }
    })
}

module.exports = makeTarget
