'use strict'

const fs = require('fs')
const Target = require('../Target')

class IsproTarget extends Target.Target {
    constructor(fileName, config) {
        super(fileName)
        this.config = config
    }

    fileContent(fileName) {
        let Content = null
        fs.readFile(fileName, 'utf8', function (err, content) {
            if (err) throw err
            Content = content
        })
        return Content
    }

    fileDescription(fileContent) {
        let re = /^-- ([^(]+)\(.*$/s
        let matchResult = fileContent.match(re)
        console.log('matchResult', matchResult)
        return matchResult && matchResult.length > 1 ? matchResult[1].trim() : null
    }

    makeFile() {
        try {
            let content = this.fileContent(this.fileName)
            let description = this.fileDescription(content) || this.fileName
            this.state = Target.FILE_CREATED
        }
        catch (err) {
            this.state = Target.FILE_ERROR
            this.err = err
        }
    }
}

module.exports = IsproTarget
