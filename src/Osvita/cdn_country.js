'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')

const Entity = require('../entity/SimpleEntity')
const TARGET_FILE_NAME = 'Країни світу (cdn_country).csv'

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
                { id: 804, code: 'UKR', name: 'Україна' }
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
