'use strict'

const FILE_CREATED = 'created'
const FILE_ERROR = 'error'
const FILE_EMPTY = 'empty'

class Target {
    constructor() {
        this.fullFileName = null
        this.state = null
        this.err = null
        this.recordsCount = 0
        this.append = false
        this.sourceFullFileName = null
    }
}

module.exports = {
    Target,
    FILE_CREATED,
    FILE_ERROR,
    FILE_EMPTY
}
