'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')

const Entity = require('../entity/SimpleEntity')
const TARGET_FILE_NAME = 'Рівень освіти (hr_dictEducationLevel).csv'

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
                { id: 1, code: '1', name: 'Базова загальна середня' },
                { id: 2, code: '2', name: 'Повна загальна середня' },
                { id: 3, code: '3', name: 'Середня спеціальна' },
                { id: 4, code: '4', name: 'Професійно-технічна' },
                { id: 5, code: '5', name: 'Неповна вища' },
                { id: 6, code: '6', name: 'Базова вища' },
                { id: 7, code: '7', name: 'Повна вища' }
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
