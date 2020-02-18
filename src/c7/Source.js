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
            let targetPromiseList = makeTargetPromiseList(config,  async (target) => {
                sendFile(target)
                targetList.push(target)
                if (targetList.length == targetPromiseList.length) {
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
                }
            })
            await Promise.all(targetPromiseList)
        } catch (err) {
            sendFailed(err.message)
        }
    }

    async getFirmName() {
        try {
            let firmName = 'Підприємство (1Cv7)'
            return firmName;
        } catch (err) {
            console.log('getFirmName', err)
            return null
        }
    }
}

function makeTargetPromiseList(config, sendFile) {
    dictionary = new Dictionary(config)
    return [hr_department(config, dictionary, sendFile)]
}

module.exports = C7Source
