'use strict'

const Entity = require('./Entity')

class EmployeePosition extends Entity {
    constructor () {
        super()
        this.ID = ''
        this.employeeID = ''
        this.taxCode = ''
        this.tabNum = ''
        this.employeeNumberID = ''
        this.departmentID = ''
        this.positionID = ''
        this.dictPositionID = ''
        this.dateFrom = ''
        this.dateTo = ''
        this.changeDateTo = ''
        this.workScheduleID = ''
        this.workerType = ''
        this.mtCount = ''
        this.description = ''
        this.dictRankID = ''
        this.dictStaffCatID = ''
        this.payElID = ''
        this.accrualSum = ''
        this.raiseSalary = ''
        this.isIndex = ''
        this.isActive = ''
        this.workPlace = ''
        this.dictFundSourceID = ''
        this.dictCategoryECBID = ''
        this.accountID = ''
        this.orgID = ''
        this.appointmentDate = ''
        this.orderNumber = ''
        this.orderDate = ''
        this.dictTarifCoeffID = ''
        this.dictProgClassID = ''
    }
}

module.exports = EmployeePosition
