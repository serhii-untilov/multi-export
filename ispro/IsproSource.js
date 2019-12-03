'use strict'

const fs = require('fs')
const Source = require('../Source')
const Target = require('../Target')
const IsproTarget = require('./IsproTarget')

const SQL_FILES_DIR = './assets/ispro'

class IsproSource extends Source {
    constructor() {
        super()
    }

    read(config, resolve) {
        fs.readdir(SQL_FILES_DIR, function(err, files) {
            if (err) throw err

            let fileList = files.map(function(file) {
                return SQL_FILES_DIR + '/' + file
            })

            for (let i = 0; i < fileList.length; i++) {
                fs.readFile(fileList[i], 'utf8', function (err, content) {
                    if (err) throw err
                    let target = new IsproTarget(fileList[i])
                    target.makeFile(content, config)
                    resolve(target)
                })
            }
        })
    }
}

module.exports = IsproSource
