'use strict'

const path = require('path')

const FILE_CREATED = 'created'
const FILE_ERROR = 'error'
const FILE_EMPTY = 'empty'

const FILE_EXT = '.csv'

class Target {
    constructor(fileName) {
        this.fileName = fileName
        this.state = null
        this.err = null
        this.targetFile = null
    }
    
    getTargetFileName(config) {
        let fileName = path.parse(this.fileName).name
        let targetPath = config.targetPath[config.targetPath.length - 1] == path.sep ? config.targetPath : `${config.targetPath}${path.sep}`
        return `${targetPath}${fileName}${FILE_EXT}`
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
