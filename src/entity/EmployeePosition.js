'use strict'

const Entity = require('./Entity')

class EmployeePosition extends Entity {
    constructor() {
        super()
        this.ID = 0
        this.employeeID = 0
        this.taxCode = ''
        this.tabNum = 0
        this.employeeNumberID = 0
        this.departmentID = 0
        this.positionID = 0
        this.dateFrom = ''
        this.dateTo = ''
        this.changeDateTo = ''
        this.workScheduleID = 0
        this.workerType = ''
        this.mtCount = 0
        this.description = ''
        this.dictRankID = 0
        this.dictStaffCatID = 0
        this.payElID = 0
        this.accrualSum = ''
        this.raiseSalary = ''
        this.isIndex = ''
        this.isActive = ''
        this.workPlace = ''
        this.dictFundSourceID = 0
        this.dictCategoryECBID = 0
        this.accountID = 0
    }
}

module.exports = EmployeePosition