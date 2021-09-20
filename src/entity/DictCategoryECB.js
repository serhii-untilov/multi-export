'use strict'

const Entity = require('./Entity')

class DictCategoryECB extends Entity {
    constructor () {
        super()
        this.ID = 0
        this.code = ''
        this.name = ''
    }
}

module.exports = DictCategoryECB
