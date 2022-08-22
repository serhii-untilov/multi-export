'use strict'

const { DBtype } = require('../Config')
// const QueryStream = require('pg-query-stream')

function makeQuery (dbType, dbName, tableName, tableStruct) {
    return new Promise((resolve, reject) => {
        switch (dbType) {
        case DBtype.POSTGRES:
            resolve(makeQueryPostgres(dbName, tableName, tableStruct))
            break
        case DBtype.MSSQL:
            resolve(makeQuerySqlServer(dbName, tableName, tableStruct))
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

function makeQueryPostgres (dbName, tableName, tableStruct) {
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
    queryText += ` FROM ${dbName}.${tableName} t1`
    return queryText
}

function makeQuerySqlServer (dbName, tableName, tableStruct) {
    let queryText = 'SELECT '
    tableStruct.forEach((column, index) => {
        if (index) { queryText += ', ' }
        queryText += column.column_name
    })
    queryText += ` FROM ${dbName}.${tableName}`
    return queryText
}

function addWhereOrgID (queryText, orgID) {
    if (queryText.search(/\WorgID\W/gi) >= 0) {
        return queryText + ` where orgID = ${orgID}`
    } else if (queryText.search(/\WorganizationID\W/gi) >= 0) {
        return queryText + ` where organizationID = ${orgID}`
    } else {
        return queryText
    }
}

module.exports = {
    getTableStruct,
    makeQuery,
    addWhereOrgID
}
