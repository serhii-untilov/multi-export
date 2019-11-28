'use strict'

const Target = require('../Target')

class IsproTarget extends Target.Target {
    constructor (fileName, config) {
        super(fileName)
        this.config = config
        this.sql = null        
    }

    makeFile() {
        // TODO: Implement creating file
        setTimeout(function(){}, 1000);
        this.state = Target.FILE_CREATED
    }
}

module.exports = IsproTarget
