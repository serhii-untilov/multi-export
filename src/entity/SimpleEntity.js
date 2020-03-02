'use strict'

const Entity = require('./Entity')

class SimpleEntity extends Entity{
    constructor() {
        super()
        this.ID = 0
        this.code = ''
        this.name = ''
        this.description = ''
    }
}

module.exports = SimpleEntity