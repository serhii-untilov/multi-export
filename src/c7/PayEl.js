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

    get_header() {
        let buffer = 'ID;code;name;methodID;description;dateFrom;dateTo;roundUpTo'
        buffer += ';isAutoCalc;isRecalculate;calcProportion;calcSumType;periodType'
        buffer += ';dictExperienceID;calcMounth;averageMethod;typePrepayment'
        buffer += ';prepaymentDay;dictFundSourceID\n'
        return buffer
    }

    get_record() {
        let buffer = `${ID};${code};${name};${methodID};${description};${dateFrom};${dateTo};${roundUpTo}`
        buffer += `;${isAutoCalc};${isRecalculate};${calcProportion};${calcSumType};${periodType}`
        buffer += `;${dictExperienceID};${calcMounth};${averageMethod};${typePrepayment}`
        buffer += `;${prepaymentDay};${dictFundSourceID}\n`
        return buffer
    }
}

module.exports = PayEl