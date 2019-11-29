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
        try {
            fs.readFile(this.fileName, 'utf8', function (err, contents) {
                if (err) throw err        

                let re = /(^--\s*)([\S ][^(]+)(.*$)/s
                let result = re.exec(contents)
                console.log('result', fileName, result)

                // TODO: Implement creating file
            })
            this.state = Target.FILE_CREATED
        }
        catch (err) {
            this.state = Target.FILE_ERROR
            this.err = err
        }
    }
}

module.exports = IsproTarget
