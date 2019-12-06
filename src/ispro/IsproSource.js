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

    read(config, sendFile) {
        fs.readdir(SQL_FILES_DIR, function (err, files) {
            // Make files
            for (let i = 0; i < files.length; i++) {
                try {
                    fs.readFile(files[i], 'utf8', function (err, queryText) {
                        let target = new IsproTarget(files[i])
                        target.makeFile(config, queryText)
                        sendFile(target)
                    })
                } catch (err) {
                    confole.log(err)
                    let target = new IsproTarget(files[i])
                    target.state = Target.FILE_ERROR
                    target.err = err
                    sendFile(target)
                }
            }
        })
    }
}

module.exports = IsproSource
