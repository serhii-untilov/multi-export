'use strict'

const Entity = require('./Entity')

class Position extends Entity {
    constructor() {
        super()
        this.ID = 0
        this.code = ''
        this.name = ''
        this.fullName = ''
        this.parentUnitID = 0
        this.state = 'ACTIVE'
        this.psCategory = ''	
        this.positionType = ''
        this.dictProfessionID = ''	
        this.dictWagePayID = 0	
        this.description = ''	
        this.nameGen = ''	
        this.nameDat = ''	
        this.fullNameGen = ''	
        this.fullNameDat = ''	
        this.nameOr = ''
        this.fullNameOr = ''	
        this.quantity = 0
        this.personalType = ''	
        this.positionCategory = ''	
        this.dictStatePayID = ''	
        this.accrualSum = ''	
        this.payElID = ''	
        this.dictStaffCatID = ''	
        this.dictFundSourceID = ''
        this.nameAcc = ''	
        this.fullNameAcc = ''	
        this.entryOrderID = ''
        this.nameLoc = ''
        this.fullNameLoc = ''	
        this.nameNom = ''
        this.nameVoc = ''
        this.fullNameNom = ''	
        this.fullNameVoc = ''
        this.liquidate = '0' 
    }
}

module.exports = Position