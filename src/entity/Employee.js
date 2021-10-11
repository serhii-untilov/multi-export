'use strict'

const Entity = require('./Entity')

class Employee extends Entity {
    constructor () {
        super()
        this.ID = ''
        this.name = ''
        this.lastName = ''
        this.firstName = ''
        this.middleName = ''
        this.shortFIO = ''
        this.fullFIO = ''
        this.genName = ''
        this.datName = ''
        this.tabNum = ''
        this.sexType = ''
        this.birthDate = ''
        this.taxCode = ''
        this.email = ''
        this.description = ''
        this.locName = ''
        this.dayBirthDate = ''
        this.monthBirthDate = ''
        this.yearBirthDate = ''
        this.organizationID = ''
    }
}

module.exports = Employee
