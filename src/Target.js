'use strict'

const path = require('path')

const FILE_CREATED = 'created'
const FILE_ERROR = 'error'
const FILE_EMPTY = 'empty'

const FILE_EXT = '.csv'

class Target {
    constructor() {
        this.fileName = null
        this.state = null
        this.err = null
        this.recordsCount = 0
    }
}

function getTargetFileName(config, sourceFileName) {
    let fileName = path.parse(sourceFileName).name
    let targetPath = config.targetPath[config.targetPath.length - 1] == path.sep 
        ? config.targetPath 
        : `${config.targetPath}${path.sep}`
    let targetFileName = `${targetPath}${fileName}${FILE_EXT}`
    return targetFileName
}

module.exports = {
    Target,
    getTargetFileName,

    FILE_CREATED,
    FILE_ERROR,
    FILE_EMPTY,

    FILE_EXT
}
