'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')
const makeFile = require('./TargetOsvita')
const dateFormat = require('../helper/dateFormat')

const Entity = require('../entity/EmployeeDocs')
const TARGET_FILE_NAME = 'Документи працівників (hr_employeeDocs).csv'

function setRecord(record, recordNumber) {
    if (this.mapper) this.mapper(record)
    if (this.filter && !this.filter(record)) return false
    const ID = Number(record.TAB) + Number(record.BOL) * 10000 * Math.pow(100, record.UWOL || 0)
    this.entity.ID = ID
    this.entity.employeeID = ID
    this.entity.taxCode = record.IKOD
    this.entity.fullFIO = record.FAM + ' ' + record.IM + ' ' + record.OT

    this.entity.dictDocKindID = '1'
    this.entity.docSeries = record.PASPS
    this.entity.docNumber = record.PASPN
    this.entity.docIssued = record.PASPK
    this.entity.docIssuedDate = record.PASPD ? dateFormat(record.PASPD) : ''
    this.entity.state = '1'
    this.entity.description = 'Паспорт'

    return !!(this.entity.docNumber || this.entity.docSeries)
}

function makeTarget(config, dictionary, sourceFile, index) {
    const target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = sourceFile
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    target.append = index > 0
    target.baseDate = new Date(config.osvitaBaseDate || '2022-01-01')
    target.filter = config.filter
    target.mapper = config.mapper
    return makeFile(target)
}

module.exports = makeTarget
