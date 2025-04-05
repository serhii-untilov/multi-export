'use strict'

const Entity = require('./Entity')

class EmployeeAccrual extends Entity {
    constructor() {
        super()
        this.ID = ''
        this.employeeID = ''
        this.tabNum = ''
        this.taxCode = ''
        this.employeeNumberID = ''
        this.payElID = ''
        this.dateFrom = ''
        this.dateTo = '9999-12-31'
        this.accrualSum = ''
        this.accrualRate = ''
        this.orderNumber = ''
        this.orderDatefrom = ''
    }
}

module.exports = EmployeeAccrual
