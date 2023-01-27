'use strict'

const fs = require('fs')
const { Pool } = require('pg')
const dbConfig = require('./dbConfig.json')

const POOL_SIZE = 4
const CONNECTION_TIMEOUT = 20 * 60 * 1000 // 20 minutes
const REQUEST_TIMEOUT = 20 * 60 * 1000 // 20 minutes

test('postgres', async () => {
    const testString = 'abc123абв'
    dbConfig.connectionTimeoutMillis = CONNECTION_TIMEOUT
    dbConfig.idleTimeoutMillis = REQUEST_TIMEOUT
    dbConfig.max = POOL_SIZE
    const pool = new Pool(dbConfig)
    pool.on('error', (err) => {
        console.log(err)
    })
    const client = await pool.connect()
    const query1 = `select '${testString}' "testString";`
    const query2 = await (async () => readQueryFromFile('./Test.sql'))()
    expect(query2).toBe(query1)
    const res = await client.query(query2)
    client.release(true)
    const response = res.rows.length ? res.rows[0].testString : null
    expect(response).toBe(testString)
})

function readQueryFromFile (fileName) {
    return new Promise((resolve, reject) => {
        try {
            fs.readFile(fileName, { encoding: 'utf8' }, (err, queryText) => {
                if (err) reject(err)
                // const convertedQueryText = iconv.encode(queryText, 'win1251')
                // resolve(convertedQueryText)
                resolve(queryText)
            })
        } catch (err) {
            reject(err)
        }
    })
}
