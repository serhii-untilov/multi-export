'use strict'

const Entity = require('./Entity')

class Accrual extends Entity {
    constructor() {
        super()
        this.ID = ''
        this.periodCalc = ''
        this.periodSalary = ''
        this.tabNum = ''
        this.employeeNumberID = ''
        this.payElID = ''
        this.baseSum = ''
        this.rate = ''
        this.paySum = ''
        this.days = ''
        this.hours = ''
        this.calculateDate = ''
        this.mask = ''
        this.flagsRec = ''
        this.flagsFix = ''
        this.planHours = ''
        this.planDays = ''
        this.maskAdd = ''
        this.dateFrom = ''
        this.dateTo = ''
        this.source = ''
        this.sourceID = ''
        this.dateFromAvg = ''
        this.dateToAvg = ''
        this.sumAvg = ''
        this.dictProgClassID = ''
        this.dictFundSourceID = ''
    }
}

module.exports = Accrual
