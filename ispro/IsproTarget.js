'use strict'

const Target = require('../Target')
const {Const} = require('../Constants')

class IsproTarget extends Target {
    constructor (fileName, config) {
        super(fileName)
        this.config = config
        this.sql = null        
    }

    makeFile() {
        setTimeout(function(){}, 1000);
        this.state = Const.FILE_CREATED
    }
}

module.exports = IsproTarget
