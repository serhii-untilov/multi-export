'use strict'

const Target = require('../Target')

class IsproTarget extends Target.Target {
    constructor(fileName) {
        super(fileName)
    }

    makeFile(content, config) {
        try {
            this.state = Target.FILE_CREATED
        }
        catch (err) {
            console.log(fileName, err)
            this.state = Target.FILE_ERROR
            this.err = err
        }
    }
}

module.exports = IsproTarget
