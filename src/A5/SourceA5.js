'use strict'

const { Pool } = require('pg')
const sql = require('mssql')
const Source = require('../Source')
const Target = require('../Target')
const makeDir = require('../helper/makeDir')
const makeFile = require('./TargetA5')
const getFullFileName = require('../helper/getFullFileName')
const makeArchive = require('../helper/makeArchive')
const removeTargetFiles = require('../helper/removeTargetFiles')
const { DBtype } = require('../Config')

const FILE_NAME = 'A5.zip'

const POOL_SIZE = 4
const CONNECTION_TIMEOUT = 20 * 60 * 1000 // 20 minutes
const REQUEST_TIMEOUT = 20 * 60 * 1000 // 20 minutes
const ACQUIRE_TIMEOUT = 20 * 60 * 1000 // 20 minutes

const tableList = [
    {
        name: 'ac_address',
        description: 'Адреси працівників',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'ownerID', orgID: 'organizationID' }
        ]
    },
    { name: 'ac_bank', description: 'Банки' },
    { name: 'ac_contractor', description: 'Контрагенти' },
    { name: 'ac_contrAccount', description: 'Розрахункові рахунки контрагентів' },
    { name: 'gl_account', description: 'Бухгалтерські рахунки' },
    { name: 'ac_dictDocKind', description: 'Види документів' },
    { name: 'ac_dictProgClass', description: 'Код програмної класифікації' },
    { name: 'ac_fundSource', description: 'Джерело фінансування' },
    { name: 'ac_dictCostType', description: 'Місце виникнення виробничих витрат' },
    { name: 'cdn_country', description: 'Країни світу' },
    { name: 'cdn_contacttype', description: 'Типи контактів' },
    { name: 'hr_accrual', description: 'Архів розрахункових листів' },
    {
        name: 'hr_accrualDt',
        description: 'Деталізація записів Розрахункового листа',
        join: [
            { name: 'hr_accrual', masterField: 'ID', detailField: 'accrualID', orgID: 'orgID' }
        ]
    },
    {
        name: 'hr_taxIndividAcc',
        description: 'ПДФО за видами доходу розрахункового листа',
        join: [
            { name: 'hr_accrual', masterField: 'ID', detailField: 'accrualID', orgID: 'orgID' }
        ]
    },
    { name: 'hr_department', description: 'Підрозділи' },
    { name: 'hr_dictBenefitsKind', description: 'Види пільг' },
    { name: 'hr_dictCategoryECB', description: 'Категорії застрахованих осіб' },
    { name: 'hr_dictEducationLevel', description: 'Рівні освіти' },
    { name: 'hr_dictAreasOfEducation', description: 'Напрями освіти' },
    { name: 'hr_dictExperience', description: 'Види стажу' },
    { name: 'hr_dictPosition', description: 'Довідник посад' },
    { name: 'hr_positionFundSource', description: 'Деталізація записів штатних посад' },
    { name: 'hr_position', description: 'Штатні позиції' },
    { name: 'hr_positionAccrual', description: 'Нарахування штатної позиції' },
    { name: 'hr_dictPositionGroup', description: 'Група посади' },
    { name: 'hr_dictPositionKind', description: 'Вид посади' },
    { name: 'hr_dictStaffCat', description: 'Категорії персоналу' },
    { name: 'hr_dictVacationKind', description: 'Види відпусток' },
    { name: 'hr_dictBonusKind', description: 'Види нагород' },
    { name: 'hr_dictAddInfKind', description: 'Види додаткової інформації' },
    { name: 'hr_dictBonusType', description: 'Типи нагород' },
    { name: 'hr_dictBonus', description: 'Нагороди' },
    { name: 'hr_dictLanguageLevel', description: 'Рівні володіння мовою' },
    { name: 'hr_dictLanguage', description: 'Іноземні мови' },
    { name: 'hr_dictKinshipKind', description: 'Ступені споріднення' },
    { name: 'hr_dictSalaryScheme', description: 'Схема посадових окладів' },
    { name: 'hr_dictSalarySchemeLevel', description: 'Рівень посадового окладу' },
    { name: 'hr_importDictPenalty' },
    { name: 'hr_dictPenaltyReason', description: 'Причини стягнень' },
    { name: 'hr_dictPenalty', description: 'Види стягнень' },
    { name: 'hr_dictMaritalStatusKind', description: 'Сімейний стан' },
    { name: 'hr_dictEmpCategory', description: 'Кваліфікаційна категорія' },
    { name: 'hr_dictRank', description: 'Ранги держслужбовця' },
    { name: 'hr_specialty', description: 'Спеціальності' },
    { name: 'hr_dictBranchScience', description: 'Галузі науки' },
    { name: 'hr_dictDegree', description: 'Наукові ступені' },
    { name: 'hr_dictAcademStatus', description: 'Вчені звання' },
    { name: 'hr_dictMilitaryRank', description: 'Військові звання' },
    { name: 'hr_dictMilitarySpeciality', description: 'Військово-облікові спеціальності' },
    { name: 'hr_dictMilitaryProfile', description: 'Профілі підготовки офіцерів запасу' },
    { name: 'hr_dictProfCompDevelopForm', description: 'Форма підвищення рівня професійної компетентності' },
    { name: 'hr_dictProfCompetency', description: 'Професійні компетенції' },
    { name: 'hr_dictTrainingTopic', description: 'Орієнтовні тематики професійного навчання' },
    { name: 'hr_dictTrainingKind', description: 'Види професійної підготовки' },
    { name: 'hr_dictStateMilitary', description: 'Стани обліку військовозобов`язаних' },
    { name: 'hr_dictCategMilitary', description: 'Категорії обліку військовозобов`язаних' },
    { name: 'hr_dictMilitarySuitable', description: 'Придатність до військової служби' },
    { name: 'hr_dictMilitaryGroup', description: 'Групи обліку військовозобов`язаних' },
    { name: 'hr_dictDisabilityType', description: 'Види інвалідності' },
    { name: 'hr_dictTimeCost', description: 'Види обліку робочого часу' },
    { name: 'hr_dictTarifCoeff', description: 'Тарифний розряд' },
    { name: 'hr_dictStaffSubCat', description: 'Підкатегорії персоналу' },
    {
        name: 'hr_employee',
        description: 'Фізичні особи',
        join: [
            { name: 'hr_employeeNumber', masterField: 'employeeID', detailField: 'ID', orgID: 'orgID' }
        ]
    },
    {
        name: 'hr_employeeLanguage',
        description: 'Володіння мовами',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_empAcademStatus',
        description: 'Вчені звання працівника',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_empRangeScience',
        description: 'Науковий ступінь',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_employeeVacation',
        description: 'Відпустка працівника (архів)',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_empStateMilitary',
        description: 'Військовий облік',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_employeeAccrual',
        description: 'Постійні нарахування працівників',
        join: [
            { name: 'hr_employeeNumber', masterField: 'ID', detailField: 'employeeNumberID', orgID: 'orgID' }
        ]
    },
    {
        name: 'hr_employeeBenefits',
        description: 'Право на пільги',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_empVacationPeriod',
        description: 'Право на відпустку',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_employeeDocs',
        description: 'Документи працівника',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_employeeEducation',
        description: 'Освіта працівників',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_empCertificatnUp',
        description: 'Підвищення кваліфікації',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_empCertificationAcc',
        description: 'Атестація працівників',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_empAddInform',
        description: 'Додаткова інформація',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_employeeDisability',
        description: 'Інвалідність працівників',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_employeeBonus',
        description: 'Нагороди',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_employeeContact',
        description: 'Інші контакти',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_empLongTermAbsc',
        description: 'Довготривала відсутність',
        join: [
            { name: 'hr_employeeNumber', masterField: 'ID', detailField: 'employeeNumberID', orgID: 'orgID' }
        ]
    },
    {
        name: 'hr_employeeExperience',
        description: 'Стаж роботи працівників',
        join: [
            { name: 'hr_employeeNumber', masterField: 'ID', detailField: 'employeeNumberID', orgID: 'orgID' }
        ]
    },
    {
        name: 'hr_employeePenalty',
        description: 'Стягнення працівників',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_employeeDocAudit',
        description: 'Спецперевірки',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_employeeWorkbook',
        description: 'Трудова книжка',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_people',
        description: 'Фізичні особи',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    {
        name: 'hr_employeeFamily',
        description: 'Члени сім\'ї',
        join: [
            { name: 'hr_employee', masterField: 'ID', detailField: 'employeeID', orgID: 'organizationID' }
        ]
    },
    { name: 'hr_employeeNumber', description: 'Працівники (Особові рахунки)' },
    {
        name: 'hr_employeePosition',
        description: 'Призначення працівників',
        join: [
            { name: 'hr_employeeNumber', masterField: 'ID', detailField: 'employeeNumberID', orgID: 'orgID' }
        ]
    },
    {
        name: 'hr_employeeAccrual',
        description: 'Постійні нарахування працівників',
        join: [
            { name: 'hr_employeeNumber', masterField: 'ID', detailField: 'employeeNumberID', orgID: 'orgID' }
        ]
    },
    {
        name: 'hr_accrualBalance',
        description: 'Сальдо по місяцям',
        join: [
            { name: 'hr_employeeNumber', masterField: 'ID', detailField: 'employeeNumberID', orgID: 'orgID' }
        ]
    },
    {
        name: 'hr_accrualFund',
        description: 'Архів розрахунку нарахувань на зарплату',
        orgID: 'orgID'
    },
    {
        name: 'hr_accrualFundDt',
        description: 'Деталізація записів нарахувань на зарплату',
        join: [
            { name: 'hr_accrualFund', masterField: 'ID', detailField: 'accrualFundID', orgID: 'orgID' }
        ]
    },
    {
        name: 'hr_payCalcDateFrom',
        description: 'Дата початку перерахунку зарплати працівників',
        join: [
            { name: 'hr_employeeNumber', masterField: 'ID', detailField: 'employeeNumberID', orgID: 'orgID' }
        ]
    },
    {
        name: 'hr_empPosFundSource',
        description: 'Деталізація записів призначення працівників',
        join: [
            { name: 'hr_employeePosition', masterField: 'ID', detailField: 'employeePositionID' },
            { name: 'hr_employeeNumber', masterField: 'ID', detailField: 'employeeNumberID', orgID: 'orgID' }
        ]
    },
    {
        name: 'hr_employeeTaxLimit',
        description: 'Пільги ПДФО працівників',
        join: [
            { name: 'hr_employeeNumber', masterField: 'ID', detailField: 'employeeNumberID', orgID: 'orgID' }
        ]
    },
    { name: 'hr_organization', orgID: 'orgID', description: 'Організації' },
    { name: 'ac_organization', orgID: 'ID', description: 'Організації' },
    { name: 'ac_orgAccount', description: 'Розрахункові рахунки організації' },
    { name: 'hr_method', description: 'Методи розрахунку видів оплати' },
    { name: 'hr_payEl', description: 'Види оплати' },
    { name: 'hr_payElEntry', description: 'Таблиця входження видів оплати' },
    { name: 'hr_payOut', description: 'Шаблони виплати' },
    { name: 'hr_payFundMethod', description: 'Методи розрахунку нарахувань на зарплату' },
    { name: 'hr_payFund', description: 'Нарахування на зарплату' },
    { name: 'hr_payFundBase', description: 'Таблиця входження видів оплати у нарахування на зарплату' },
    { name: 'hr_payPerm', description: 'Постійні нарахування і утримання по організації' },
    { name: 'hr_dictTaxIndivid', description: 'Види доходу ПДФО' },
    { name: 'hr_payElTaxIndivid', description: 'Таблиця входження видів оплати у види доходу ПДФО' },
    {
        name: 'hr_payRetention',
        description: 'Постійні утримання працівників',
        join: [
            { name: 'hr_employeeNumber', masterField: 'ID', detailField: 'employeeNumberID', orgID: 'orgID' }
        ]
    },
    { name: 'hr_taxLimit', description: 'Довідник пільг ПДФО' },
    { name: 'hr_workSchedule', description: 'Графіки роботи' },
    { name: 'hr_workScheduleDays', description: 'Періоди графіків роботи' }
]

class SourceA5 extends Source {
    async read (config, sendFile, sendDone, sendFailed) {
        try {
            const pool = config.a5dbType === DBtype.POSTGRES
                ? new Pool(dbConfig(config))
                : config.a5dbType === DBtype.MSSQL
                    ? new sql.ConnectionPool(dbConfig(config))
                    : null
            pool.on('error', (err) => {
                console.log(err)
                sendFailed(err.message)
            })
            await makeDir(config.targetPath)
            const orgID = await getOrgID(config.a5dbType, config.a5Database, config.a5orgCode, pool)
            const orgName = await getOrgName(config.a5dbType, config.a5Database, orgID, pool)
            Promise.all(tableList.map((table) => {
                return new Promise((resolve, reject) => {
                    pool.connect()
                        .then(client => {
                            const target = new Target.Target()
                            target.table = table
                            target.fullFileName = getFullFileName(config.targetPath, `${table.description} (${table.name}).csv`)
                            target.config = config
                            target.client = client
                            target.orgID = orgID
                            return target
                        })
                        .then(target => makeFile(target))
                        .then(target => {
                            sendFile(target)
                            target.client.release(true)
                            resolve(target)
                        })
                        .catch(err => reject(err))
                })
            })).then((targetList) => {
                if (config.isArchive) {
                    const arcFileName = getFullFileName(config.targetPath, orgName ? `${orgName}.zip` : FILE_NAME)
                    makeArchive(arcFileName, targetList)
                        .then(() => removeTargetFiles(targetList))
                        .then(() => sendDone(arcFileName))
                        .catch(err => {
                            sendFailed(err.message)
                        })
                } else {
                    sendDone(null)
                }
            })
        } catch (error) {
            sendFailed(error.message)
        }
    }
}

function dbConfig (config) {
    if (config.a5dbType === DBtype.POSTGRES) {
        return {
            host: config.a5Host,
            port: config.a5Port,
            user: config.a5Login,
            password: config.a5Password,
            database: config.a5Database,
            connectionTimeoutMillis: CONNECTION_TIMEOUT,
            idleTimeoutMillis: REQUEST_TIMEOUT,
            max: POOL_SIZE
        }
    } else if (config.a5dbType === DBtype.MSSQL) {
        return {
            user: config.a5Login,
            password: config.a5Password,
            server: config.a5Host,
            database: config.a5Database,
            port: Number(config.a5Port),
            connectionTimeout: CONNECTION_TIMEOUT,
            requestTimeout: REQUEST_TIMEOUT,
            pool: {
                max: POOL_SIZE,
                min: 0,
                acquireTimeoutMillis: ACQUIRE_TIMEOUT
            }
        }
    } else {
        throw (new Error(`Unknown dbType (${config.a5dbType}).`))
    }
}

async function getOrgID (dbType, dbName, orgCode, pool) {
    if (!orgCode) return null
    switch (dbType) {
    case DBtype.POSTGRES: {
        const client = await pool.connect()
        const res = await client.query(`select max(ID) ID from ${dbName}.ac_organization where (code = '${orgCode}' or okpocode = '${orgCode}') and mi_deleteDate >= '9999-12-31';`)
        client.release(true)
        return res.rows.length ? res.rows[0].id : null
    }
    case DBtype.MSSQL: {
        const client = await pool.connect()
        const request = await client.request() // or: new sql.Request(pool1)
        const res = await request.query(`select max(ID) ID from ac_organization where (code = '${orgCode}' or okpocode = '${orgCode}') and mi_deleteDate >= '9999-12-31'`)
        return res.recordset.length ? res.recordset[0].ID : null
    }
    default:
        throw new Error(`Unknown dbType (${dbType}).`)
    }
}

async function getOrgName (dbType, dbName, orgID, pool) {
    if (!orgID) return null
    switch (dbType) {
    case DBtype.POSTGRES: {
        const client = await pool.connect()
        const res = await client.query(`select name from ${dbName}.ac_organization where id = ${orgID};`)
        client.release(true)
        return res.rows.length ? res.rows[0].name : null
    }
    case DBtype.MSSQL: {
        const client = await pool.connect()
        const request = await client.request() // or: new sql.Request(pool1)
        const res = await request.query(`select name from ac_organization where id = ${orgID}`)
        return res.recordset.length ? res.recordset[0].name : null
    }
    default:
        throw new Error(`Unknown dbType (${dbType}).`)
    }
}

module.exports = SourceA5
