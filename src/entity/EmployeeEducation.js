'use strict'

const Entity = require('./Entity')

class EmployeeEducation extends Entity {
    constructor() {
        super()
        this.ID = ''
        this.employeeID = ''
        this.taxCode = ''
        this.fullFIO = ''
        this.dictEducationLevelID = ''
        this.dateFrom = ''
        this.dateTo = ''
    }
}

module.exports = EmployeeEducation
