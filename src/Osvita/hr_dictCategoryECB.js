'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')

const ECB1  = 1     // Наймані працівники на загальних підставах
const ECB2  = 2     // Працюючі інваліди
const ECB3  = 3     // особи, які працюють за угодами ЦПХ
const ECB25 = 25    // Держслужбовець
const ECB32 = 32    // Держслужбовець - інвалід

// Be attentive to fill this section
const Entity = require('../entity/DictCategoryECB')
const TARGET_FILE_NAME = 'Категорії застрахованих осіб ЄСВ (hr_dictCategoryECB).csv'

function setRecord(record) {
    this.entity.ID = record.id
    this.entity.code = record.code
    this.entity.name = record.name
    this.entity.description = `${this.entity.name} (${this.entity.code})`
    this.dictionary.setDictCategoryECBID(this.entity.code, this.entity.ID)
    return true
}

function makeTarget(config, dictionary) {
    let target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

const makeFile = function (target) {
    return new Promise(async (resolve, reject) => {
        try {
            if (!target.append)
                await removeFile(target.fullFileName)
            let buffer = target.append ? '' : target.entity.getHeader()
            const source = [
                {id: ECB1 , code: '1', name: 'Наймані працівники на загальних підставах'},
                {id: ECB2 , code: '2', name: 'Працюючі інваліди'},
                {id: ECB3 , code: '3', name: 'особи, які працюють за угодами ЦПХ'},
                {id: ECB25, code: '25', name: 'Держслужбовець'},
                {id: ECB32, code: '32', name: 'Держслужбовець - інвалід'}
            ]
            source.forEach((record) => {
                if (target.setRecord(record)) {
                    target.recordsCount++
                    buffer += target.entity.getRecord()
                    fs.appendFile(target.fullFileName, buffer, (err) => {
                        if (err) throw err
                    })
                    buffer = ''
                }
            })
            target.state = target.recordsCount ? Target.FILE_CREATED : Target.FILE_EMPTY
            resolve(target)
        } catch (err) {
            console.error(err)
            reject(err)
        }
    })
}

module.exports = {
    ECB1,
    ECB2,
    ECB3,
    ECB25,
    ECB32,
    makeTarget
}
