'use strict'

const Entity = require('./Entity')

class PayOut extends Entity {
    constructor () {
        super()
        this.ID = ''
        this.code = ''
        this.name = ''
        this.orgID = ''
        this.description = ''
    }
}

module.exports = PayOut
