'use strict'

class Department {
    constructor() {
        this.ID = 0
        this.code = ''
        this.name = ''
        this.parentUnitID = 0
        this.state = 'ACTIVE'
        this.fullName = ''
        this.description = ''
        this.nameGen = ''
        this.fullNameGen = ''
        this.nameDat =''
        this.fullNameDat = ''            
        this.nameOr = ''
        this.fullNameOr = ''
        this.dateFrom = ''
        this.dateTo = ''
    }

    getHeader() {
        return 'ID;code;name;parentUnitID;state;fullName;description;nameGen;fullNameGen;nameDat;fullNameDat;nameOr;' +
            'fullNameOr;dateFrom;dateTo\n'
    }

    getRecord() {
        return `${this.ID};${this.code};${this.name};${this.parentUnitID};${this.state};${this.fullName};${this.description};`
            + `${this.nameGen};${this.fullNameGen};${this.nameDat};${this.fullNameDat};${this.nameOr};${this.fullNameOr};`
            + `${this.dateFrom};${this.dateTo}\n`
    }
}

module.exports = Department