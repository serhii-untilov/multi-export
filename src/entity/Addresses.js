'use strict'

const Entity = require('./Entity')

class Addresses extends Entity {
    constructor() {
        super()
        this.ID = ''
        this.orgID = ''
        this.ownerID = ''
        this.addressType = ''
        this.postIndex = ''
        this.address = ''
        this.countryID = ''
    }
}

module.exports = Addresses
