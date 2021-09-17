'use strict'

const Entity = require('./Entity')

class PayRetention extends Entity {
    constructor() {
        super()
        this.ID = 0
        this.employeeID = 0
        this.taxCode = ''
        this.tabNum = 0
        this.employeeNumberID = 0
        this.dateFrom = ''
        this.dateTo = ''
        this.payElID = 0
        this.rate = ''
        this.baseSum = ''
    }
}

module.exports = PayRetention