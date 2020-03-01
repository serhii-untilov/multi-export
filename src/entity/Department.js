'use strict'

const Entity = require('./Entity')

class Department extends Entity {
    constructor() {
        super()
        this.ID = 0
        this.code = ''
        this.name = ''
        this.parentUnitID = 0
        this.state = 'ACTIVE'
        this.fullName = ''
        this.description = ''
        this.nameGen = ''
        this.fullNameGen = ''
        this.nameDat =''
        this.fullNameDat = ''            
        this.nameOr = ''
        this.fullNameOr = ''
        this.dateFrom = ''
        this.dateTo = ''
    }
}

module.exports = Department