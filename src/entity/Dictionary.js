'use strict'
const fs = require('fs')
const PayEl = require('./PayEl')
const getFullFileName = require('../helper/getFullFileName')

class Dictionary {
    constructor (config) {
        this.config = config
        this.taxCode = {}
        this.payElID = {}
        this.payElUsed = new Set()
        this.departmentID = {}
        this.workScheduleID = {}
        this.positionID = {}
        this.dictPositionName = {}
        this.dictPositionID = []
        this.employeeFullName = {}
        this.dictStaffCatID = {}
        this.catID_SchedID = {}
        this.taxLimitID = {}
        this.taxLimitUsed = new Set()
        this.organization = []
        this.organizationID = {}
        this.fundSourceID = {}
        this.payOutID = {}
        this.payOut = []
        this.dictCategoryECBID = {}
        this.dictStaffCatIDbyPath = []
        this.dictTarifCoeffIDbyName = []
        this.dictEducationLevelIDbyName = []
        this.experienceByName = []
        this.dictProgClass = []
        this.dictProgClassID = {}
        this.dictFundSourceID = {}
        this.employeeNumberID = []

        this.commonID = 0
        this.entityID = {}
        this.employeeExperienceID = 0
        this.errorCount = 0
    }

    setEmployeeNumberID (employeeNumberID) {
        this.employeeNumberID.push(employeeNumberID)
    }

    findEmployeeNumberID (employeeNumberID) {
        return !!this.employeeNumberID.find(o => o === employeeNumberID)
    }

    setDictFundSourceID (employeeNumberID, dictFundSourceID) {
        if (dictFundSourceID) {
            this.dictFundSourceID[employeeNumberID] = dictFundSourceID
        }
    }

    getDictFundSourceID (employeeNumberID) {
        return this.dictFundSourceID[employeeNumberID] || ''
    }

    setDictProgClassID (employeeNumberID, dictProgClassID) {
        if (dictProgClassID) {
            this.dictProgClassID[employeeNumberID] = dictProgClassID
        }
    }

    getDictProgClassID (employeeNumberID) {
        return this.dictProgClassID[employeeNumberID] || ''
    }

    getNextDictProgClassID (code) {
        const found = this.dictProgClass.find(o => o.code === code)
        if (found) { return found.ID }
        const maxID = this.dictProgClass.reduce((a, b) => { return Math.max(a, b.ID) }, 0)
        return maxID + 1
    }

    setDictProgClass (code, ID) {
        this.dictProgClass.push({ code, ID })
    }

    getDictProgClass (code) {
        return this.dictProgClass.find(o => o.code === code)
    }

    getEmployeeExperienceID () {
        return ++this.employeeExperienceID
    }

    setExperienceByName (lastName, firstName, middleName, years, months, days) {
        this.experienceByName.push({ lastName, firstName, middleName, years, months, days })
    }

    getExperienceByName (lastName, firstName, middleName) {
        return this.experienceByName.find(o => o.lastName.toUpperCase() === lastName.toUpperCase() && o.firstName.toUpperCase() === firstName.toUpperCase() && o.middleName.toUpperCase() === middleName.toUpperCase())
    }

    setDictEducationLevelIDbyName (lastName, firstName, middleName, dictEducationLevelID) {
        this.dictEducationLevelIDbyName.push({ lastName, firstName, middleName, dictEducationLevelID })
    }

    getDictEducationLevelIDbyName (lastName, firstName, middleName) {
        return this.dictEducationLevelIDbyName.find(o => o.lastName.toUpperCase() === lastName.toUpperCase() && o.firstName.toUpperCase() === firstName.toUpperCase() && o.middleName.toUpperCase() === middleName.toUpperCase())
    }

    setDictTarifCoeffIDbyName (lastName, firstName, middleName, dictTarifCoeffID) {
        this.dictTarifCoeffIDbyName.push({ lastName, firstName, middleName, dictTarifCoeffID })
    }

    getDictTarifCoeffIDbyName (lastName, firstName, middleName) {
        return this.dictTarifCoeffIDbyName.find(o => o.lastName.toUpperCase() === lastName.toUpperCase() && o.firstName.toUpperCase() === firstName.toUpperCase() && o.middleName.toUpperCase() === middleName.toUpperCase())
    }

    setTaxLimitUsed (code) {
        if (!this.taxLimitUsed.has(code)) {
            this.taxLimitUsed.add(code)
        }
    }

    isTaxLimitUsed (code) {
        return this.taxLimitUsed.has(code)
    }

    setTaxLimitID (code, ID) {
        this.taxLimitID[code] = ID
    }

    getTaxLimitID (code) {
        return this.taxLimitID[code]
    }

    setPayElUsed (cd) {
        const code = cd.substring(0, 32)
        if (!this.payElUsed.has(code)) {
            this.payElUsed.add(code)
        }
    }

    isPayElUsed (cd) {
        const code = cd.substring(0, 32)
        return this.payElUsed.has(code)
    }

    setDictStaffCatID_WorkScheduleID (catID, schedID) {
        this.catID_SchedID[catID] = schedID
    }

    getDictStaffCatID_WorkScheduleID (catID) {
        return this.catID_SchedID[catID]
    }

    setDictStaffCatID (code, ID) {
        this.dictStaffCatID[code] = ID
    }

    getDictStaffCatID (code) {
        return this.dictStaffCatID[code]
    }

    getDictStaffCatIDbyPath (code, path) {
        code = code.toString()
        const found = this.dictStaffCatIDbyPath.find(o => o.code === code && o.path === path)
        return found ? found.ID : null
    }

    setDictStaffCatIDbyPath (code, name, path) {
        code = code.toString()
        const found = this.dictStaffCatIDbyPath.find(o => o.name === name)
        const ID = found ? found.ID : this.getCommonID()
        this.dictStaffCatIDbyPath.push({ ID, code, name, path })
        return !!found // already exists
    }

    getEntityID (name) {
        this.entityID[name] = this.entityID[name] ? this.entityID[name] + 1 : 1
        return this.entityID[name]
    }

    getCommonID () {
        return ++this.commonID
    }

    setEmployeeFullName (ID, fullName) {
        this.employeeFullName[ID] = fullName
    }

    getEmployeeFullName (ID) {
        return this.employeeFullName[ID]
    }

    setDictPositionName (ID, name) {
        this.dictPositionName[ID] = name
    }

    getDictPositionName (ID) {
        return this.dictPositionName[ID]
    }

    getDictPositionIDbyPath (code, path) {
        code = code.toString()
        const found = this.dictPositionID.find(o => o.code === code && o.path === path)
        return found ? found.ID : null
    }

    getDictPositionNamebyPath (code, path) {
        code = code.toString()
        const found = this.dictPositionID.find(o => o.code === code && o.path === path)
        return found ? found.name : null
    }

    setDictPositionIDbyPath (code, name, path) {
        code = code.toString()
        const found = this.dictPositionID.find(o => o.name === name)
        const ID = found ? found.ID : this.getCommonID()
        this.dictPositionID.push({ ID, code, name, path })
        return !!found
    }

    setPositionID (ID) {
        this.positionID[ID] = ID // for check presense
    }

    getPositionID (ID) {
        return this.positionID[ID] // to check presense
    }

    setWorkScheduleID (code, ID) {
        this.workScheduleID[code] = ID
    }

    getWorkScheduleID (code) {
        return this.workScheduleID[code]
    }

    setDepartmentID (code, ID) {
        this.departmentID[code] = ID
    }

    getDepartmentID (code) {
        return this.departmentID[code] || ''
    }

    setOrganizationID (code, ID) {
        this.organizationID[code] = ID
    }

    getOrganizationID (code) {
        return this.organizationID[code] || ''
    }

    setOrganization (ID, code, name, edrpou) {
        this.organization.push({ ID, code, name, edrpou })
    }

    getOrganization (ID) {
        return this.organization.find(o => o.ID === ID)
    }

    setFundSourceID (code, ID) {
        this.fundSourceID[code] = ID
    }

    getFundSourceID (code) {
        return this.fundSourceID[code] || ''
    }

    setPayOutID (code, ID) {
        this.payOutID[code] = ID
    }

    getPayOutID (code) {
        return this.payOutID[code] || ''
    }

    getPayOut (code, path) {
        code = code.toString()
        return this.payOut.find(o => o.code === code && o.path === path)
    }

    setPayOut (ID, code, name, path) {
        code = code.toString()
        this.payOut.push({ ID, code, name, path })
    }

    setDictCategoryECBID (code, ID) {
        this.dictCategoryECBID[code] = ID
    }

    getDictCategoryECBID (code) {
        return this.dictCategoryECBID[code] || ''
    }

    setTaxCode (tabNum, taxCode) {
        this.taxCode[tabNum] = taxCode
    }

    getTaxCode (tabNum) {
        return this.taxCode[tabNum] || ''
    }

    setPayElID (cd, payElID) {
        const code = cd.substring(0, 32)
        this.payElID[code] = payElID
    }

    getPayElID (cd) {
        const code = cd.substring(0, 32)
        if (this.payElID[code]) {
            return this.payElID[code]
        } else {
            let ID = Object.keys(this.payElID).length + 1
            ID = this._append_hr_payEl(ID, code, code)
            if (!ID) {
                this.errorCount += 1
                console.log('Error [' + this.errorCount + ']. Not found PayElCd: ' + code + '.')
            } else {
                this.setPayElID(code, ID)
            }
            return ID
        }
    }

    _append_hr_payEl (ID, code, name) {
        const fileName = getFullFileName(this.config.targetPath, 'Види оплати (hr_payEl).csv')
        try {
            const payEl = new PayEl()
            payEl.ID = ID
            payEl.code = code
            payEl.name = name
            payEl.description = payEl.name + '(' + payEl.code + ')'
            const buffer = payEl.getRecord()
            fs.appendFileSync(fileName, buffer)
            console.log('Append', fileName, ID, code, name)
            return ID
        } catch (err) {
            console.log('Not added', fileName, err.message)
            return 0
        }
    }
}

module.exports = Dictionary
