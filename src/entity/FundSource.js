'use strict'

const Entity = require('./Entity')

class FundSource extends Entity {
    constructor() {
        super()
        this.ID	= 0
        this.code = ''
        this.name = ''
        this.dateFrom = ''
        this.dateTo = ''
        this.description = ''
        }
}

module.exports = FundSource