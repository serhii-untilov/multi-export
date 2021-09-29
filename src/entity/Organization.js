'use strict'

const Entity = require('./Entity')

class Organization extends Entity {
    constructor () {
        super()
        this.ID = 0
        this.EDRPOUCode = ''
        this.code = ''
        this.name = ''
        this.taxCode = ''
        this.idxNum = ''
        this.parentUnitID = 0
        this.state = 'ACTIVE'
        this.fullName = ''
        this.description = ''
        this.nameGen = ''
        this.fullNameGen = ''
        this.nameDat = ''
        this.fullNameDat = ''
        this.nameOr = ''
        this.fullNameOr = ''
        this.dateFrom = ''
        this.dateTo = ''
    }
}

module.exports = Organization
