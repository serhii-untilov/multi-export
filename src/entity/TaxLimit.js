'use strict'

const Entity = require('./Entity')

class TaxLimit extends Entity {
    constructor () {
        super()
        this.ID = ''
        this.code = ''
        this.name = ''
        this.taxLimitType = ''
        this.size = ''
        this.codeForReport = ''
        this.dateFrom = ''
        this.dateTo = ''
    }
}

module.exports = TaxLimit
