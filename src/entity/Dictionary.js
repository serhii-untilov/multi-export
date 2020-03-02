'use strict'
const fs = require('fs')
const PayEl = require('./PayEl')

class Dictionary {
    constructor(config) {
        this.config = config
        this.TaxCode = {}
        this.PayElID = {}
        this.DepartmentID = {}
        this.WorkScheduleID = {}
        this.PositionID = {}
        this.DictPositionName = {}
        this.EmployeeFullName = {}
        this.commonID = 0
        this.error_count = 0
    }

    getCommonID() {
        return ++this.commonID
    }

    setEmployeeFullName(ID, fullName) {
        this.EmployeeFullName[ID] = fullName
    }

    getEmployeeFullName(ID) {
        return this.EmployeeFullName[ID]
    }

    setDictPositionName(ID, name) {
        this.DictPositionName[ID] = name
    }

    getDictPositionName(ID) {
        return this.DictPositionName[ID]
    }

    setPositionID(ID) {
        this.PositionID[ID] = ID    // for check presense
    }

    getPositionID(ID) {
        return this.PositionID[ID] // to check presense
    }

    setWorkScheduleID(code, ID) {
        this.WorkScheduleID[code] = ID
    }

    getWorkScheduleID(code) {
        return this.WorkScheduleID[code]
    }

    setDepartmentID(code, ID) {
        this.DepartmentID[code] = ID
    }

    getDepartmentID(code) {
        return this.DepartmentID[code] || ''
    }

    setTaxCode(tabNum, taxCode) {
        this.TaxCode[tabNum] = taxCode
    }

    getTaxCode(tabNum) {
        return this.TaxCode[tabNum] || ''
    }
        

    setPayElID(cd, payElID) {
        this.PayElID[cd] = payElID
    }

    getPayElID(cd) {
        try {
            return this.PayElID[cd] || 0
        } catch(err) {
            let ID = len(self.PayElID) + 1                    
            ID = _append_hr_payEl(ID, cd, cd)
            if (ID == 0) {
                this.error_count += 1
                console.log('Error [' + str(this.error_count) + ']. Not found PayElCd: ' + cd + '.')
            } else {
                this.setPayElID(cd, ID)
            }
            return ID
        }
    }

    async _append_hr_payEl(ID, code, name) {
        fileName = this.config.targetPath + 'hr_payEl.csv'
        try {
            payEl = new PayEl()
            payEl.ID = ID
            payEl.code = code
            payEl.name = name
            payEl.description = payEl.name + '(' + payEl.code + ')'
            let buffer = payEl.getRecord()
            fs.appendFileSync(fileName, buffer)
            console.log('Append', fileName, ID, code, name)
            return ID
        } catch(err) {
            console.log('Not added', fileName, err.message)
            return 0
        }
    }
}

module.exports = Dictionary