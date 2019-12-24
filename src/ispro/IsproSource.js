'use strict'

const fs = require('fs')
const archiver = require('archiver')

const Source = require('../Source')
const Target = require('../Target')
const makeFile = require('./IsproTarget')

const SQL_FILES_DIR = './assets/ispro/'

function getFileList() {
    return new Promise((resolve, reject) => {
        fs.readdir(SQL_FILES_DIR, (err, fileList) => {
            if (err) reject(err);
            resolve(fileList)
        })
    })
}

function makeTaskList(config, fileList, sendFile) {
    return fileList.map((fileName) => {
        return new Promise(async (resolve) => {
            let target = new Target.Target()
            target.fileName = Target.getTargetFileName(config, fileName)
            target.queryFileName = SQL_FILES_DIR + fileName
            target.config = config
            target = await makeFile(target)
            sendFile(target)
            resolve(true)
        })
    })
}

class IsproSource extends Source {
    constructor() {
        super()
    }

    async read(config, sendFile) {
        let fileList = await getFileList()
        let taskList = makeTaskList(config, fileList, sendFile)
        await Promise.all(taskList)
    }
}

module.exports = IsproSource
