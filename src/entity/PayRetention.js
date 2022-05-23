'use strict'

const Entity = require('./Entity')

class PayRetention extends Entity {
    constructor () {
        super()
        this.ID = ''
        this.employeeID = ''
        this.taxCode = ''
        this.tabNum = ''
        this.employeeNumberID = ''
        this.dateFrom = ''
        this.dateTo = ''
        this.payElID = ''
        this.rate = ''
        this.baseSum = ''
        this.paymentMethod = '1' // Банк
    }
}

module.exports = PayRetention
