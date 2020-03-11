'use strict'

const Entity = require('./Entity')

class TaxLimit extends Entity {
    constructor() {
        super()
        this.ID	= 0
        this.code = ''
        this.name = ''
        this.taxLimitType = ''
        this.size = 0
        this.codeForReport = ''
        this.dateFrom = ''
        this.dateTo = ''
        }
}

module.exports = TaxLimit