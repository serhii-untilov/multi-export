

const fs = require('fs')
const { Pool } = require('pg')

const POOL_SIZE = 4
const CONNECTION_TIMEOUT = 20 * 60 * 1000 // 20 minutes
const REQUEST_TIMEOUT = 20 * 60 * 1000 // 20 minutes

test.skip('postgres', async () => {
    const testString = 'abc123абв'
    const dbConfig = require('./dbConfig.json')
    dbConfig.connectionTimeoutMillis = CONNECTION_TIMEOUT
    dbConfig.idleTimeoutMillis = REQUEST_TIMEOUT
    dbConfig.max = POOL_SIZE
    const pool = new Pool(dbConfig)
    pool.on('error', (err) => {
        console.log(err)
    })
    const client = await pool.connect()
    const query1 = `select '${testString}' "testString";`
    let query2 = await (async () => readQueryFromFile('./Test.sql'))()
    query2 = query2
        .replace(/\n/g, ' ')
        .replace(/\r/g, ' ')
        .replace(/\s{2,}/gm, ' ')
        .trim()
    query2 = query2.replace(/\r/g, ' ').trim()
    expect(query2).toBe(query1)
    const res = await client.query(query2)
    client.release(true)
    const response = res.rows.length ? res.rows[0].testString : null
    expect(response).toBe(testString)
})

function readQueryFromFile(fileName) {
    return new Promise((resolve, reject) => {
        try {
            fs.readFile(fileName, { encoding: 'utf8' }, (err, queryText) => {
                if (err) reject(err)
                // const convertedQueryText = iconv.encode(queryText, 'win1251')
                // resolve(convertedQueryText)
                // Remove BOM if present
                if (queryText.charCodeAt(0) === 0xFEFF) {
                    queryText = queryText.slice(1);
                }
                resolve(queryText)
            })
        } catch (err) {
            reject(err)
        }
    })
}
