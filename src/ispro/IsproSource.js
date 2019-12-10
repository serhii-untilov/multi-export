'use strict'

const fs = require('fs')
const archiver = require('archiver')

const Source = require('../Source')
const Target = require('../Target')
const IsproTarget = require('./IsproTarget')

const SQL_FILES_DIR = './assets/ispro'

class IsproSource extends Source {
    constructor() {
        super()
    }

    readDir() {
        return new Promise((resolve, reject) => {
            return fs.readdir(SQL_FILES_DIR, (err, fileList) => {
                err === undefined ? resolve(fileList) : reject(err)
            })
        })
    }

    readFileList(config, fileList, sendFile) {
        return fileList.map((fileName) => {
            return new Promise((resolve, reject) => {
                try {
                    resolve(this.readFile(config, fileName, sendFile))
                } catch (err) {
                    reject(err)
                }
            })
        })
    }

    readFile(config, fileName, sendFile) {
        console.log(fileName)
        return fileName
    }

    read(config, sendFile, sendDone) {
        this.readDir()
            .then((fileList) => this.readFileList(config, fileList, sendFile))
            .then(() => sendDone())
            .catch((err) => {
                throw(err)
            } )
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
