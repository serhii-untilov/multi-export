'use strict'

const Entity = require('./Entity')

class Accrual extends Entity {
    constructor () {
        super()
        this.ID = 0
        this.periodCalc = ''
        this.periodSalary = ''
        this.tabNum = 0
        this.employeeNumberID = 0
        this.payElID = 0
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
        this.sourceID = 0
        this.dateFromAvg = ''
        this.dateToAvg = ''
        this.sumAvg = ''
    }
}

module.exports = Accrual
