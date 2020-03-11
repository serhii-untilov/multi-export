'use strict'

const Entity = require('./Entity')

class EmployeeTaxLimit extends Entity {
    constructor() {
        super()
        this.ID = 0
        this.employeeID = 0
        this.taxCode = ''
        this.tabNum = 0
        this.employeeNumberID = 0
        this.dateFrom = ''
        this.dateTo = ''
        this.taxLimitID = ''
        this.amountChild = ''
    }
}

module.exports = EmployeeTaxLimit