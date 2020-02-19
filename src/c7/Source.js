'use strict'

const Source = require('../Source')
const Target = require('../Target')
const Dictionary = require('./Dictionary')
const hr_department = require('./hr_department')
const ArchiveMaker = require('../ArchiveMaker')

class C7Source extends Source {
    constructor() {
        super()
    }

    async read(config, sendFile, sendDone, sendFailed) {
        try {
            let targetList = []
            let dictionary = new Dictionary(config)
            let target = await hr_department(config, dictionary, sendFile)
            sendFile(target)
            targetList.push(target)
            if (config.isArchive) {
                let firmName = await this.getFirmName()
                let arc = new ArchiveMaker(config, firmName)
                arc.make(targetList, (arcFileName) => {
                    Target.removeFiles(targetList)
                    sendDone(arcFileName)
                })
            } else {
                sendDone()
            }
        } catch (err) {
            sendFailed(err.message)
        }
    }

    async getFirmName() {
        try {
            let firmName = 'export_data_1Cv7'
            return firmName;
        } catch (err) {
            console.log('getFirmName', err)
            return null
        }
    }
}

// function makeTargetPromiseList(config, sendFile) {
//     let dictionary = new Dictionary(config)
//     console.log('Before promise')
//     let promise = makePromise(config, dictionary, sendFile)
//     con
//     console.log('After promise')
//     return []
// }

module.exports = C7Source
