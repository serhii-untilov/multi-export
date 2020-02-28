'use strict'

const Source = require('../Source')
const Dictionary = require('./Dictionary')
const hr_department = require('./hr_department')
const hr_dictPosition = require('./hr_dictPosition')
const fullFileName = require('../helper/fullFileName')
const makeArchive = require('../helper/makeArchive')
const removeTargetFiles = require('../helper/removeTargetFiles')
const hr_position = require('./hr_position')
const hr_workSchedule = require('./hr_workSchedule')

const ARC_FILE_NAME = '1Cv7.zip'

class C7Source extends Source {
    constructor() {
        super()
    }

    async read(config, sendFile, sendDone, sendFailed) {
        try {
            let targetList = []
            let dictionary = new Dictionary(config)
            let arcFileName = null
            hr_dictPosition(config).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_department(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => hr_workSchedule(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })                
                .then(() => hr_position(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })                
                .then(() => {
                    if (config.isArchive) {
                        arcFileName = fullFileName(config.targetPath, ARC_FILE_NAME)
                        return makeArchive(arcFileName, targetList)
                    }
                })
                .then(() => {
                    if (config.isArchive) {
                        removeTargetFiles(targetList)
                    }
                })
                .then(() => sendDone(arcFileName))
                .catch((err) => sendFailed(err))
        } catch (err) {
            sendFailed(err.message)
        }
    }
}

module.exports = C7Source
