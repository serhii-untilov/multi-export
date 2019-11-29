'use strict'

const fs = require('fs')
const Source = require('../Source')
const Target = require('../Target')
const IsproTarget = require('./IsproTarget')

const SQL_FILES_DIR = './assets/ispro'

class Ispro extends Source {
    constructor(config) {
        super()
        this.config = config
    }

    read(resolve) {
        let config = this.config
        fs.readdir(SQL_FILES_DIR, function(err, files) {
            if (err) throw err

            let fileList = files.map(function(file) {
                return SQL_FILES_DIR + '/' + file
            })

            for (let i = 0; i < fileList.length; i++) {
                let target = new IsproTarget(fileList[i], config)
                target.makeFile()
                resolve(target)
            }
        })
    }
}

module.exports = Ispro
