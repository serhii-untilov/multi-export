'use strict'

const Entity = require('./Entity')

class EmployeeAccrual extends Entity {
    constructor () {
        super()
        this.ID = 0
        this.employeeID = 0
        this.tabNum = 0
        this.taxCode = ''
        this.employeeNumberID = 0
        this.payElID = 0
        this.dateFrom = ''
        this.dateTo = '9999-12-31'
        this.accrualSum = ''
        this.accrualRate = ''
        this.orderNumber = ''
        this.orderDatefrom = ''
    }
}

module.exports = EmployeeAccrual
