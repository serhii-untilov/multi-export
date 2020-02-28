'use strict'
const fs = require('fs')
const PayEl = require('../entity/PayEl')

class Dictionary {
    constructor(config) {
        this.config = config
        this.TaxCode = {}
        this.PayElID = {}
        this.DepartmentID = {}
        this.WorkScheduleID = {}
        this.error_count = 0
    }

    set_WorkScheduleID(code, ID) {
        this.WorkScheduleID[code] = ID
    }

    get_WorkScheduleID(code) {
        return this.WorkScheduleID[code]
    }

    set_DepartmentID(code, ID) {
        this.DepartmentID[code] = ID
    }

    get_DepartmentID(code) {
        return this.DepartmentID[code] || ''
    }

    set_TaxCode(tabNum, taxCode) {
        this.TaxCode[tabNum] = taxCode
    }

    get_TaxCode(tabNum) {
        return this.TaxCode[tabNum] || ''
    }
        

    set_PayElID(cd, payElID) {
        this.PayElID[cd] = payElID
    }

    get_PayElID(cd) {
        try {
            return this.PayElID[cd] || 0
        } catch(err) {
            let ID = len(self.PayElID) + 1                    
            ID = _append_hr_payEl(ID, cd, cd)
            if (ID == 0) {
                this.error_count += 1
                console.log('Error [' + str(this.error_count) + ']. Not found PayElCd: ' + cd + '.')
            } else {
                this.set_PayElID(cd, ID)
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
            let buffer = payEl.get_record()
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