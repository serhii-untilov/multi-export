'use strict'

const fs = require('fs')
const Target = require('../Target')

class IsproTarget extends Target.Target {
    constructor(fileName, config) {
        super(fileName)
        this.config = config
    }

    makeFile() {
        let config = this.config
        let fileName = this.fileName
        fs.readFile(this.fileName, 'utf8', function (err, contents) {
            if (err) throw err        

            // TODO: Implement creating file
            let re = '(^\s?--\s?)([^(]*)(\()([^)]*)(.*)'
            let resullt = re.exec(contents)
            console.log(fileName, result)

            this.state = Target.FILE_CREATED
        })
    }
}

module.exports = IsproTarget
