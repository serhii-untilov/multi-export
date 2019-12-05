'use strict'

const fs = require('fs')
const path = require('path')
const Source = require('../Source')
const Target = require('../Target')
const IsproTarget = require('./IsproTarget')

const SQL_FILES_DIR = './assets/ispro'

class IsproSource extends Source {
    constructor() {
        super()
    }

    read(config, resolve) {
        fs.readdir(SQL_FILES_DIR, function (err, files) {
            for (let i = 0; i < files.length; i++) {
                try {
                    fs.readFile(files[i], 'utf8', function (err, queryText) {
                        let target = new IsproTarget(files[i])
                        target.makeFile(config, queryText)
                        resolve(target)
                    })
                } catch (err) {
                    confole.log(err)
                    let target = new IsproTarget(files[i])
                    target.state = Target.FILE_ERROR
                    target.err = err
                    resolve(target)
                }
            }
        })
    }
}

module.exports = IsproSource
