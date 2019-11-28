'use strict'

const FILE_CREATED = 'created'
const FILE_ERROR = 'error'
const FILE_EMPTY = 'empty'

class Target {
    constructor(fileName) {
        this.fileName = fileName
        this.state = null
        this.err = null
    }
    
    makeFile() {
        throw 'Not implemented method'
    }
}

module.exports = {
    Target,
    FILE_CREATED,
    FILE_ERROR,
    FILE_EMPTY,
}
