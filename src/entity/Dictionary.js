'use strict'
const fs = require('fs')
const PayEl = require('./PayEl')
const getFullFileName = require('../helper/getFullFileName')

class Dictionary {
    constructor(config) {
        this.config = config
        this.TaxCode = {}
        this.PayElID = {}
        this.payElUsed = new Set()        
        this.DepartmentID = {}
        this.WorkScheduleID = {}
        this.PositionID = {}
        this.DictPositionName = {}
        this.EmployeeFullName = {}
        this.DictStaffCatID = {}
        this.catID_SchedID = {}
        this.TaxLimitID = {}
        this.TaxLimitUsed = new Set()        


        this.commonID = 0
        this.error_count = 0
    }

    setTaxLimitUsed(code) {
        if (!this.TaxLimitUsed.has(code))
            this.TaxLimitUsed.add(code)
    }

    isTaxLimitUsed(code) {
        return this.TaxLimitUsed.has(code)
    }    

    setTaxLimitID(code, ID) {
        this.TaxLimitID[code] = ID
    }

    getTaxLimitID(code) {
        return this.TaxLimitID[code]
    }


    setPayElUsed(cd) {
        let code = cd.substring(0, 32)
        if (!this.payElUsed.has(code))
            this.payElUsed.add(code)
    }

    isPayElUsed(cd) {
        let code = cd.substring(0, 32)
        return this.payElUsed.has(code)
    }

    setDictStaffCatID_WorkScheduleID(catID, schedID) {
        this.catID_SchedID[catID] = schedID
    }

    getDictStaffCatID_WorkScheduleID(catID) {
        return this.catID_SchedID[catID]
    }

    setDictStaffCatID(code, ID) {
        this.DictStaffCatID[code] = ID
    }

    getDictStaffCatID(code) {
        return this.DictStaffCatID[code]
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
        let code = cd.substring(0, 32)
        this.PayElID[code] = payElID
    }

    getPayElID(cd) {
        let code = cd.substring(0, 32)
        if (this.PayElID[code]) {
            return this.PayElID[code]
        } else {
            let ID = Object.keys(this.PayElID).length + 1                    
            ID = this._append_hr_payEl(ID, code, code)
            if (!ID) {
                this.error_count += 1
                console.log('Error [' + this.error_count + ']. Not found PayElCd: ' + code + '.')
            } else {
                this.setPayElID(code, ID)
            }
            return ID
        }
    }

    _append_hr_payEl(ID, code, name) {
        let fileName = getFullFileName(this.config.targetPath, 'Види оплати (hr_payEl).csv')
        try {
            let payEl = new PayEl()
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