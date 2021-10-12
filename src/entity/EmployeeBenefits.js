'use strict'

const Entity = require('./Entity')

class EmployeeBenefits extends Entity {
    constructor () {
        super()
        this.ID = ''
        this.orgID = ''
        this.employeeID = ''
        this.dictBenefitsKindID = ''
        this.dateFrom = ''
        this.dateTo = ''
        this.docNumber = ''
        this.docDate = ''
        this.issued = ''
    }
}

module.exports = EmployeeBenefits
