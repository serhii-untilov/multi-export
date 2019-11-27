'use strict'

class Target {
    constructor (fileName) {
        this.fileName = fileName
        this.state = null
        this.err = null
    }
    makeFile() {
        throw 'Not implemented method'
    }
}

module.exports = Target