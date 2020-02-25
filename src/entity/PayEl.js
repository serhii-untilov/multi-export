'use strict'

class PayEl {
    constructor() {
        this.ID = 0
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

    getHeader() {
        return 'ID;code;name;methodID;description;dateFrom;dateTo;roundUpTo'
            + ';isAutoCalc;isRecalculate;calcProportion;calcSumType;periodType'
            + ';dictExperienceID;calcMounth;averageMethod;typePrepayment'
            + ';prepaymentDay;dictFundSourceID\n'
    }

    getRecord() {
        return `${this.ID};${this.code};${this.name};${this.methodID};${this.description};${this.dateFrom};`
            + `${this.dateTo};${this.roundUpTo};${this.isAutoCalc};${this.isRecalculate};${this.calcProportion};`
            + `${this.calcSumType};${this.periodType};${this.dictExperienceID};${this.calcMounth};${this.averageMethod};`
            + `${this.typePrepayment};${this.prepaymentDay};${this.dictFundSourceID}\n`
    }
}

module.exports = PayEl