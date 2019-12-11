'use strict'

const fs = require('fs')
const archiver = require('archiver')

const Source = require('../Source')
const Target = require('../Target')
const IsproTarget = require('./IsproTarget')

const SQL_FILES_DIR = './assets/ispro'

function getFileList() {
    return new Promise((resolve, reject) => {
        fs.readdir(SQL_FILES_DIR, (err, fileList) => {
            if (err) reject(err);
            resolve(fileList)
        })
    })
}

function makeTaskList({ config, fileList, sendFile }) {
    return fileList.map((fileName) => {
        return new Promise((resolve, reject) => {
            let target = makeFile(config, fileName)
            sendFile(target)
            resolve(fileName)
        })
    })
}

function makeFile(config, fileName) {
    let target = new IsproTarget(fileName)
    target.targetFile = fileName
//    console.log(fileName)
    return target
}

class IsproSource extends Source {
    constructor() {
        super()
    }

    read(config, sendFile, sendDone) {
        getFileList()
            .then(fileList => makeTaskList({ config, fileList, sendFile }))
            .then(taskList => Promise.all(taskList))
            .then(sendDone())
        // .then((fileList) => this.readFileList(config, fileList, sendFile))
        //.then(sendDone())
        //.catch((err) => {
        //    throw(err)
        //})
        // fs.readdir(SQL_FILES_DIR, function (err, files) {
        //     // Make files
        //     for (let i = 0; i < files.length; i++) {
        //         try {
        //             fs.readFile(files[i], 'utf8', function (err, queryText) {
        //                 let target = new IsproTarget(files[i])
        //                 target.makeFile(config, queryText)
        //                 sendFile(target)
        //             })
        //         } catch (err) {
        //             confole.log(err)
        //             let target = new IsproTarget(files[i])
        //             target.state = Target.FILE_ERROR
        //             target.err = err
        //             sendFile(target)
        //         }
        //     }
        // })
    }
}

module.exports = IsproSource
