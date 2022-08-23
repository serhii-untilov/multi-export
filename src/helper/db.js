'use strict'

const { DBtype } = require('../Config')
// const QueryStream = require('pg-query-stream')

function makeQuery (dbType, dbName, table, tableStruct, orgID) {
    return new Promise((resolve, reject) => {
        switch (dbType) {
        case DBtype.POSTGRES:
            resolve(makeQueryPostgres(dbName, table, tableStruct, orgID))
            break
        case DBtype.MSSQL:
            resolve(makeQuerySqlServer(dbName, table, tableStruct, orgID))
            break
        default:
            reject(new Error(`Unknown dbType (${dbType}).`))
        }
    })
}

async function getTableStruct (dbType, connection, tableName) {
    switch (dbType) {
    case DBtype.POSTGRES:
        return new Promise((resolve, reject) => {
            const queryText =
            `select column_name, data_type, character_maximum_length from INFORMATION_SCHEMA.COLUMNS where table_name ='${tableName.toLowerCase()}';`
            connection.query(queryText)
                .then(res => {
                    res.rows.length ? resolve(res.rows) : reject(new Error('Table does not exists.'))
                })
                .catch(err => reject(err))
        })
    case DBtype.MSSQL:
        return new Promise((resolve, reject) => {
            const queryText =
            `select column_name, data_type, character_maximum_length from INFORMATION_SCHEMA.COLUMNS where table_name ='${tableName}';`
            const tableStruct = []
            const request = connection.request() // or: new sql.Request(pool1)
            request.stream = true
            request.query(queryText)
            request.on('error', err => reject(err))
            request.on('row', row => tableStruct.push(row))
            request.on('done', () => resolve(tableStruct))
        })
    default:
        throw new Error(`Unknown dbType (${dbType}).`)
    }
}

function makeQueryPostgres (dbName, table, tableStruct, orgID) {
    let queryText = 'SELECT '
    tableStruct
        .filter(o => o.column_name.slice(0, 3) !== 'mi_')
        .forEach((column, index) => {
            const colName = column.column_name
            const colType = column.data_type
            if (index) { queryText += ', ' }
            if (colType.includes('timestamp')) {
                queryText += `case when t1.${colName} is null then '' else concat(left(t1.${colName}::text, 4), '-', substring(t1.${colName}::text from 6 for 2), '-', substring(t1.${colName}::text from 9 for 2)) end "${colName}"`
            } else {
                queryText += `t1.${colName} "${colName}"`
            }
        })
    queryText += ` FROM ${dbName}.${table.name} t1`
    let whereText = ' WHERE 1=1'
    if (orgID && table.orgID) {
        whereText += `\nAND t1.${table.orgID} = ${orgID}\n`
    } else if (orgID && table.join) {
        let detailAlias = 't1'
        table.join.forEach((master, index) => {
            const alias = 'a' + index
            queryText += `\ninner join ${dbName}.${master.name} ${alias} on ${alias}.${master.masterField} = ${detailAlias}.${master.detailField}\n`
            if (master.orgID) {
                whereText += `\nAND ${alias}.${master.orgID} = ${orgID}\n`
            }
            detailAlias = alias
        })
    } else if (orgID) {
        whereText += addWhereOrgID(queryText, orgID)
    }
    queryText += whereText
    if (tableStruct.findIndex(o => o.column_name.toUpperCase() === 'MI_DELETEDATE') >= 0) {
        queryText += `\nAND t1.mi_deleteDate >= '9999-12-31'`
    }
    return queryText
}

function makeQuerySqlServer (dbName, table, tableStruct, orgID) {
    let queryText = 'SELECT '
    tableStruct
        .filter(o => o.column_name.slice(0, 3) !== 'mi_')
        .forEach((column, index) => {
            const colName = column.column_name
            const colType = column.data_type
            if (index) { queryText += ', ' }
            if (colType.includes('date')) {
                queryText += `cast(cast(t1.${colName} as DATE) as varchar) as ${colName}`
            } else {
                queryText += `t1.${colName}`
            }
        })
    queryText += ` FROM ${table.name} t1`
    let whereText = ' WHERE 1=1'
    if (orgID && table.orgID) {
        whereText += `\nAND t1.${table.orgID} = ${orgID}\n`
    } else if (orgID && table.join) {
        let detailAlias = 't1'
        table.join.forEach((master, index) => {
            const alias = 'a' + index
            queryText += `\ninner join ${master.name} ${alias} on ${alias}.${master.masterField} = ${detailAlias}.${master.detailField}\n`
            if (master.orgID) {
                whereText += `\nAND ${alias}.${master.orgID} = ${orgID}\n`
            }
            detailAlias = alias
        })
    } else if (orgID) {
        whereText += addWhereOrgID(queryText, orgID)
    }
    queryText += whereText
    if (tableStruct.findIndex(o => o.column_name.toUpperCase() === 'MI_DELETEDATE') >= 0) {
        queryText += `\nAND t1.mi_deleteDate >= '9999-12-31'`
    }
    return queryText
}

function addWhereOrgID (queryText, orgID) {
    if (queryText.search(/\WorgID\W/gi) >= 0) {
        return `\nAND orgID = ${orgID}`
    } else if (queryText.search(/\WorganizationID\W/gi) >= 0) {
        return `\nAND organizationID = ${orgID}`
    } else {
        return ''
    }
}

module.exports = {
    getTableStruct,
    makeQuery
}
