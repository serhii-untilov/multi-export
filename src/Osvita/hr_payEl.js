'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')

const PAYEL146 = 146 // ПЕД. ЗАРПЛ
const PAYEL147 = 147 // АДМИН ЗАРПЛ
const PAYEL246 = 246 // ЗАРПЛ ВИХОВАТЕЛЯ
const PAYEL247 = 247 // ИНША ЗАРПЛ
const PAYEL248 = 248 // ЗАРПЛ СПЕЦИАЛИСТА
const PAYEL301 = 301 // Профсоюзний внесок
const PAYEL401 = 401 // Заробіток для розрахунку лікарняного
const PAYEL402 = 402 // Заробіток для розрахунку відпустки
const PAYEL403 = 403 // Заробіток для розрахунку середнього заробітку

const Entity = require('../entity/PayEl')
const TARGET_FILE_NAME = 'Види оплати (hr_payEl).csv'

function setRecord (record) {
    this.entity.ID = record.id
    this.entity.code = record.code
    this.entity.name = record.name
    this.entity.description = `${this.entity.name} (${this.entity.code})`
    this.entity.roundUpTo = '2'
    this.entity.isAutoCalc = '1'
    this.entity.isRecalculate = '1'
    this.dictionary.setPayElID(this.entity.code, this.entity.ID)
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
                { id: PAYEL146, code: '146', name: 'Педагогічна зарплата' },
                { id: PAYEL147, code: '147', name: 'Адміністративна зарплата' },
                { id: PAYEL246, code: '246', name: 'Зарплата вихователя' },
                { id: PAYEL247, code: '247', name: 'Інша зарплата' },
                { id: PAYEL248, code: '248', name: 'Зарплата спеціаліста' },
                { id: PAYEL301, code: '301', name: 'Профсоюзний внесок' },
                { id: PAYEL401, code: '401', name: 'Заробіток для розрахунку лікарняного' },
                { id: PAYEL402, code: '402', name: 'Заробіток для розрахунку відпустки' },
                { id: PAYEL403, code: '403', name: 'Заробіток для розрахунку середнього заробітку' }
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

module.exports = {
    PAYEL146,
    PAYEL147,
    PAYEL246,
    PAYEL247,
    PAYEL248,
    PAYEL301,
    PAYEL401,
    PAYEL402,
    PAYEL403,
    makeTarget
}
