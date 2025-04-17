'use strict'

const Result = {
    FILE_CREATED: 'created',
    FILE_ERROR: 'error',
    FILE_EMPTY: 'empty'
}

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
    Result
}
