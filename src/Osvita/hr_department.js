'use strict'

const getFullFileName = require('../helper/getFullFileName')
const Target = require('../Target')

// Be attentive to fill this section
const Entity = require('../entity/Department') 
const TARGET_FILE_NAME = 'Підрозділи (hr_department).csv'

function setRecord(record, recordNumber) {
    this.entity.ID = recordNumber
    this.entity.code = record.ID
    this.entity.name = record.NM
    this.entity.parentUnitID = record.ID_PARENT ? this.dictionary.getDepartmentID(record.ID_PARENT) : ''
    this.entity.fullName = record.NMF
    this.entity.description = this.entity.name + ' (' + this.entity.code + ')'
    this.entity.dateFrom = dateFormat(record.BEG)
    this.entity.dateTo = dateFormat(record.END)
    this.dictionary.setDepartmentID(this.entity.code, this.entity.ID)
    return true
}

function makeTarget(config, dictionary) {
    let target = new Target.Target()
    target.fullFileName = getFullFileName(config.targetPath, TARGET_FILE_NAME)
    target.sourceFullFileName = getFullFileName(config.c1DbPath, SOURCE_FILE_NAME)
    target.dictionary = dictionary
    target.entity = new Entity()
    target.setRecord = setRecord
    return makeFile(target)
}

const makeFile = function (target) {
    return new Promise(async (resolve, reject) => {
        try {
            if (!target.append)
                removeFile(target.fullFileName)
            fs.exists(target.sourceFullFileName, (exists) => {
                if (exists) {
                    let buffer = target.append ? '' : target.entity.getHeader()
                    let id = 1
                    fs.createReadStream(target.sourceFullFileName)
                        .pipe(new YADBF({ 
                            // encoding: 'cp1251'
                            encoding: 'cp866'
                        }))
                        .on('data', record => {
                            if (!record.deleted) {
                                if (target.setRecord(record, id)) {
                                    target.recordsCount++
                                    id++
                                    buffer += target.entity.getRecord()
                                    fs.appendFile(target.fullFileName, buffer, (err) => {
                                        if (err) throw err
                                    })
                                    buffer = ''
                                }
                            }
                        })
                        .on('end', () => {
                            target.state = target.recordsCount ? Target.FILE_CREATED : Target.FILE_EMPTY
                            resolve(target)
                        })
                        .on('error', err => {
                            console.error(`an error was thrown: ${err}`);
                            target.state = Target.FILE_ERROR
                            target.err = err.message
                            resolve(target)
                        })
                } else {
                    target.state = Target.FILE_EMPTY
                    resolve(target)
                }
            })
        } catch (err) {
            console.error(err)
            reject(err)
        }
    })
}


module.exports = makeTarget
