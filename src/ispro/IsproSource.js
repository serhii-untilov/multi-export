'use strict'

const fs = require('fs')
const archiver = require('archiver')

const Source = require('../Source')
const Target = require('../Target')
const IsproTarget = require('./IsproTarget')

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
        return new Promise((resolve) => {
            let target = new IsproTarget(config, SQL_FILES_DIR + fileName)
            target.makeFile()
            sendFile(target)
            resolve(fileName)
        })
    })
}

class IsproSource extends Source {
    constructor() {
        super()
    }

    async read(config, sendFile, sendDone) {
        let fileList = await getFileList()
        let taskList = makeTaskList(config, fileList, sendFile)
        await Promise.all(taskList)
    }
}

module.exports = IsproSource
