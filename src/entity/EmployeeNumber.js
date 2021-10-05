'use strict'

const Entity = require('./Entity')

class EmployeeNumber extends Entity {
    constructor () {
        super()
        this.ID = ''
        this.employeeID = ''
        this.taxCode = ''
        this.tabNum = ''
        this.dateFrom = ''
        this.dateTo = ''
        this.description = ''
        this.payOutID = ''
        this.personalAccount = ''
        this.orgID = ''
    }
}

module.exports = EmployeeNumber
