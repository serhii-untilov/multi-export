'use strict'

const Source = require('../Source')
const Dictionary = require('../entity/Dictionary')
const makeDir = require('../helper/makeDir')
const getFullFileName = require('../helper/getFullFileName')
const makeArchive = require('../helper/makeArchive')
const removeTargetFiles = require('../helper/removeTargetFiles')
const hr_employee = require('./hr_employee')
const fs = require('fs')

const ARC_FILE_NAME = 'Osvita.zip'

const employeeFileMask = /^B[0-9]+\.DBF/i

class SourceOsvita extends Source {
    constructor() {
        super()
    }

    async read(config, sendFile, sendDone, sendFailed) {
        try {
            let targetList = []
            let dictionary = new Dictionary(config)
            makeDir(config.targetPath)
                .then(() => getFileList(config.osvitaDbPath, employeeFileMask))
                .then((fileList) => {
                    return Promise.all(
                        fileList.map((sourceFile, index) => {
                            return new Promise(async (resolve, reject) => {
                                hr_employee(config, dictionary, sourceFile, index)
                                    .then((target) => {
                                        if (!target.append) {
                                            targetList.push(target)
                                        }
                                        sendFile(target)
                                        resolve(target)
                                        // console.log('1', index, target.sourceFullFileName)
                                    })
                                    .catch((err) => reject(err))
                            })
                        })
                    )
                })
                .then(() => {
                    if (config.isArchive) {
                        let arcFileName = getFullFileName(config.targetPath, ARC_FILE_NAME)
                        // console.log('2', arcFileName)
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

function getFileList(sourcePath, fileMask) {
    return new Promise((resolve, reject) => {
        fs.readdir(sourcePath, { withFileTypes: true }, (err, dirents) => {
            if (err) reject(err);
            let fileList = dirents
                .filter((el) => {return !el.isDirectory() && fileMask.test(el.name)})
                .map((el) => {return getFullFileName(sourcePath, el.name)})
            resolve(fileList)
        })
    })
}

module.exports = SourceOsvita
