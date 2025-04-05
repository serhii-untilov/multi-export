'use strict'

const Entity = require('./Entity')

class EmployeeTaxLimit extends Entity {
    constructor() {
        super()
        this.ID = ''
        this.employeeID = ''
        this.taxCode = ''
        this.tabNum = ''
        this.employeeNumberID = ''
        this.dateFrom = ''
        this.dateTo = ''
        this.taxLimitID = ''
        this.amountChild = ''
    }
}

module.exports = EmployeeTaxLimit
