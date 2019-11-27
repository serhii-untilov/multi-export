'use strict'

const Source = require('../Source')
const { Const } = require('../Constants')
const IsproTarget = require('./IsproTarget')

class Ispro extends Source {
    constructor(config) {
        super()
        this.config = config
    }
    read(resolve) {
        let fileList = this.makeFileList()
        fileList.forEach(function (fileName, i, arr) {
            let target = new IsproTarget(fileName, this.config)
            try {
                target.makeFile()
            } catch (err) {
                target.state = Const.FILE_ERROR
                target.err = err
            }
            resolve(target)
        })
    }

    makeFileList() {
        return [
            'ispro__ac_bank.sql'
            , 'ispro__ac_contrAccount.sql'
            , 'ispro__ac_contractor.sql'
            , 'ispro__ac_dictdockind.sql'
            , 'ispro__gl_account.sql'
            , 'ispro__hr_accrual.sql'
            , 'ispro__hr_accrualBalance.sql'
            , 'ispro__hr_accrualFund.sql'
            , 'ispro__hr_department.sql'
            , 'ispro__hr_dictCategoryECB.sql'
            , 'ispro__hr_dictDisabilityType.sql'
            , 'ispro__hr_dictExperience.sql'
            , 'ispro__hr_dictPeriod.sql'
            , 'ispro__hr_dictStaffCat.sql'
            , 'ispro__hr_dictTaxIndivid.sql'
            , 'ispro__hr_dictTimeCost.sql'
            , 'ispro__hr_employee.sql'
            , 'ispro__hr_employeeAccrual.sql'
            , 'ispro__hr_employeeDisability.sql'
            , 'ispro__hr_employeeDocs.sql'
            , 'ispro__hr_employeeExperience.sql'
            , 'ispro__hr_employeeFamily.sql'
            , 'ispro__hr_employeeNumber.sql'
            , 'ispro__hr_employeePosition.sql'
            , 'ispro__hr_employeeTaxLimit.sql'
            , 'ispro__hr_method.sql'
            , 'ispro__hr_payEl.sql'
            , 'ispro__hr_payElEntry.sql'
            , 'ispro__hr_payElTaxIndivid.sql'
            , 'ispro__hr_payFund.sql'
            , 'ispro__hr_payFundBase.sql'
            , 'ispro__hr_payFundMethod.sql'
            , 'ispro__hr_payPerm.sql'
            , 'ispro__hr_payRetention.sql'
            , 'ispro__hr_people.sql'
            , 'ispro__hr_position.sql'
            , 'ispro__hr_taxLimit.sql'
            , 'ispro__hr_workSchedule.sql'
            , 'ispro__hr_workScheduleDays.sql'
        ]
    }
}