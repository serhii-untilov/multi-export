'use strict'

const Source = require('../Source')
const Dictionary = require('../entity/Dictionary')
const makeDir = require('../helper/makeDir')
const getFullFileName = require('../helper/getFullFileName')
const makeArchive = require('../helper/makeArchive')
const removeTargetFiles = require('../helper/removeTargetFiles')
const hr_payEl = require('./hr_payEl')

const ARC_FILE_NAME = 'Parus.zip'

class SourceParus extends Source {
    constructor() {
        super()
    }

    async read(config, sendFile, sendDone, sendFailed) {
        try {
            let targetList = []
            let dictionary = new Dictionary(config)
            
            makeDir(config.targetPath)
                .then(() => hr_payEl(config, dictionary)).then((target) => { targetList.push(target); sendFile(target) })
                .then(() => {
                    if (config.isArchive) {
                        let arcFileName = getFullFileName(config.targetPath, ARC_FILE_NAME)
                        makeArchive(arcFileName, targetList)
                        .then(() => removeTargetFiles(targetList))
                        .then(() => sendDone(arcFileName))
                        .catch((err) => sendFailed(err.message))
                    } else {
                        sendDone(null)
                    }
                })
                .catch((err) => sendFailed(err.message))
        } catch (err) {
            sendFailed(err.message)
        }
    }
}

module.exports = SourceParus
