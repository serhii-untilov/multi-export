'use strict'

const fs = require('fs')
const removeFile = require('../helper/removeFile')
const getFullFileName = require('../helper/getFullFileName')
const { Target, Result } = require('../Target')

const PAYEL001 = 1 // Нормовано в днях
const PAYEL002 = 2 // Нормовано в годинах
const PAYEL003 = 3 // за ЦПД
const PAYEL025 = 25 // Посадовий оклад
const PAYEL146 = 146 // ПЕД. ЗАРПЛ
const PAYEL147 = 147 // АДМИН ЗАРПЛ
const PAYEL178 = 178 // Відпустка для догляду за дитиною до 3-х років
const PAYEL246 = 246 // ЗАРПЛ ВИХОВАТЕЛЯ
const PAYEL247 = 247 // ИНША ЗАРПЛ
const PAYEL248 = 248 // ЗАРПЛ СПЕЦИАЛИСТА
const PAYEL249 = 249 // ЗАРПЛ МЕДПРАЦІВНИКА
const PAYEL301 = 301 // Профспілковий внесок
const PAYEL401 = 401 // Заробіток для розрахунку лікарняного
const PAYEL402 = 402 // Заробіток для розрахунку відпустки
const PAYEL403 = 403 // Заробіток для розрахунку середнього заробітку

const PAYEL006 = 6 // Надбавка до окладу
const PAYEL011 = 11 // Надбавка за ранг
const PAYEL012 = 12 // Надбавка за вислугу
const PAYEL013 = 13 // Надбавка за інтенсивність праці
const PAYEL029 = 29 // Аванс

const Entity = require('../entity/PayEl')
const TARGET_FILE_NAME = 'Види оплати (hr_payEl).csv'

function setRecord(record) {
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
                { id: PAYEL001, code: '001', name: 'Нормовано в днях' },
                { id: PAYEL002, code: '002', name: 'Нормовано в годинах' },
                { id: PAYEL003, code: '003', name: 'за ЦПД' },
                { id: PAYEL025, code: '025', name: 'Посадовий оклад' },
                { id: PAYEL146, code: '146', name: 'Педагогічна зарплата' },
                { id: PAYEL147, code: '147', name: 'Адміністративна зарплата' },
                {
                    id: PAYEL178,
                    code: '178',
                    name: 'Відпустка для догляду за дитиною до 3-х років'
                },
                { id: PAYEL246, code: '246', name: 'Зарплата вихователя' },
                { id: PAYEL247, code: '247', name: 'Інша зарплата' },
                { id: PAYEL248, code: '248', name: 'Зарплата спеціаліста' },
                { id: PAYEL249, code: '249', name: 'Зарплата медпрацівників' },
                { id: PAYEL301, code: '301', name: 'Профспілковий внесок' },
                { id: PAYEL401, code: '401', name: 'Заробіток для розрахунку лікарняного' },
                { id: PAYEL402, code: '402', name: 'Заробіток для розрахунку відпустки' },
                {
                    id: PAYEL403,
                    code: '403',
                    name: 'Заробіток для розрахунку середнього заробітку'
                },

                { id: PAYEL006, code: '006', name: 'Надбавка до окладу' },
                { id: PAYEL011, code: '011', name: 'Надбавка за ранг' },
                { id: PAYEL012, code: '012', name: 'Надбавка за вислугу' },
                { id: PAYEL013, code: '013', name: 'Надбавка за інтенсивність праці' },
                { id: PAYEL029, code: '029', name: 'Аванс' }
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

module.exports = {
    PAYEL001,
    PAYEL002,
    PAYEL003,
    PAYEL025,
    PAYEL146,
    PAYEL147,
    PAYEL178,
    PAYEL246,
    PAYEL247,
    PAYEL248,
    PAYEL249,
    PAYEL301,
    PAYEL401,
    PAYEL402,
    PAYEL403,
    PAYEL029,
    makeTarget
}
