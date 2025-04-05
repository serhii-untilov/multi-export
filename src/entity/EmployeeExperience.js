'use strict'

const Entity = require('./Entity')

class EmployeeExperience extends Entity {
    constructor() {
        super()
        this.ID = ''
        this.employeeID = ''
        this.dictExperienceID = ''
        this.calcDate = ''
        this.employeeNumberID = ''
    }
}

module.exports = EmployeeExperience
