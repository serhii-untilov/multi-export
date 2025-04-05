'use strict'

const Entity = require('./Entity')

class Department extends Entity {
    constructor() {
        super()
        this.ID = ''
        this.code = ''
        this.name = ''
        this.parentUnitID = ''
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
        this.orgID = ''
    }
}

module.exports = Department
