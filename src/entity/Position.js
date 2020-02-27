'use strict'

class Position {
    constructor() {
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

    getHeader() {
        return 'ID;code;name;fullName;parentUnitID;state;psCategory;positionType;dictProfessionID;dictWagePayID;'
            + 'description;nameGen;nameDat;fullNameGen;fullNameDat;nameOr;fullNameOr;quantity;personalType;'
            + 'positionCategory;dictStatePayID;accrualSum;payElID;dictStaffCatID;dictFundSourceID;nameAcc;'
            + 'fullNameAcc;entryOrderID;nameLoc;fullNameLoc;nameNom;nameVoc;fullNameNom;fullNameVoc;liquidate\n'
    }

    getRecord() {
        return `${this.ID};${this.code};${this.name}\n`
    }
}

module.exports = Position