'use strict'

const Entity = require('./Entity')

class EmployeeNumber extends Entity {
    constructor () {
        super()
        this.ID = 0
        this.employeeID = 0
        this.taxCode = ''
        this.tabNum = 0
        this.dateFrom = ''
        this.dateTo = ''
        this.description = ''
        this.payOutID = ''
        this.personalAccount = ''
        this.orgID = ''
    }
}

module.exports = EmployeeNumber
