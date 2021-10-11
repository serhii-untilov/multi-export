'use strict'

const Entity = require('./Entity')

class PayEl extends Entity {
    constructor () {
        super()
        this.ID = ''
        this.code = ''
        this.name = ''
        this.methodID = ''
        this.description = ''
        this.dateFrom = ''
        this.dateTo = ''
        this.roundUpTo = '2'
        this.isAutoCalc = '1'
        this.isRecalculate = '1'
        this.calcProportion = ''
        this.calcSumType = ''
        this.periodType = ''
        this.dictExperienceID = ''
        this.calcMounth = ''
        this.averageMethod = ''
        this.typePrepayment = ''
        this.prepaymentDay = ''
        this.dictFundSourceID = ''
    }
}

module.exports = PayEl
