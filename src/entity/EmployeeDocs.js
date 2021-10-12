'use strict'

const Entity = require('./Entity')

class EmployeeDocs extends Entity {
    constructor () {
        super()
        this.ID = ''
        this.employeeID = ''
        this.taxCode = ''
        this.fullFIO = ''
        this.dictDocKindID = ''
        this.docSeries = ''
        this.docNumber = ''
        this.docIssued = ''
        this.docIssuedDate = ''
        this.docValidUntil = ''
        this.state = '1'
        this.description = ''
    }
}

module.exports = EmployeeDocs
