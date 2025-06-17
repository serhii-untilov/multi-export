// https://github.com/oracle/node-oracledb/blob/main/examples/connectionpool.js

Error.stackTraceLimit = 50

const oracledb = require('oracledb')

function initOracleClient(dbConfig) {
    const libDir = dbConfig.oracleClient || ''
    const mode = libDir ? 'thick' : 'thin'
    // This example runs in both node-oracledb Thin and Thick modes.
    //
    // Optionally run in node-oracledb Thick mode
    if (mode === 'thick') {
        // Thick mode requires Oracle Client or Oracle Instant Client libraries.
        // On Windows and macOS you can specify the directory containing the
        // libraries at runtime or before Node.js starts.  On other platforms (where
        // Oracle libraries are available) the system library search path must always
        // include the Oracle library path before Node.js starts.  If the search path
        // is not correct, you will get a DPI-1047 error.  See the node-oracledb
        // installation documentation.
        let clientOpts = {}
        // On Windows and macOS platforms, set the environment variable
        // NODE_ORACLEDB_CLIENT_LIB_DIR to the Oracle Client library path
        if (process.platform === 'win32' || process.platform === 'darwin') {
            clientOpts = { libDir }
        }
        oracledb.initOracleClient(clientOpts) // enable node-oracledb Thick mode
    }
    console.log(oracledb.thin ? 'Running in thin mode' : 'Running in thick mode')
}

function getConnectString(dbConfig) {
    const port = dbConfig.server.search(':') >= 0 ? dbConfig.server.slice(dbConfig.server.search(':') + 1) : '' // 1521
    const server = (dbConfig.server.search(':') > 0 ? dbConfig.server.slice(0, dbConfig.server.search(':')) : dbConfig.server) || 'localhost'
    const schema = dbConfig.schema || 'ISPRO'
    return `(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=${server})(PORT=${port}))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=${schema})))`
}

async function init(dbConfig) {
    try {
        // Create a connection pool which will later be accessed via the
        // pool cache as the 'default' pool.
        await oracledb.createPool({
            user: dbConfig.user || 'system',
            password: dbConfig.password || 'oracle',
            connectString: getConnectString(dbConfig),
            // edition: 'ORA$BASE', // used for Edition Based Redefintion
            // events: false, // whether to handle Oracle Database FAN and RLB events or support CQN
            // externalAuth: false, // whether connections should be established using External Authentication
            // homogeneous: true, // all connections in the pool have the same credentials
            // poolAlias: 'default', // set an alias to allow access to the pool via a name.
            // poolIncrement: 1, // only grow the pool by one connection at a time
            poolMax: dbConfig.poolMax || 4, // maximum size of the pool. (Note: Increase UV_THREADPOOL_SIZE if you increase poolMax in Thick mode)
            poolMin: dbConfig.poolMin || 0, // start with no connections; let the pool shrink completely
            // poolPingInterval: 60, // check aliveness of connection if idle in the pool for 60 seconds
            poolTimeout: dbConfig.poolTimeout || 60, // terminate connections that are idle in the pool for 60 seconds
            // queueMax: 500, // don't allow more than 500 unsatisfied getConnection() calls in the pool queue
            queueTimeout: dbConfig.queueTimeout || 60000 // terminate getConnection() calls queued for longer than 60000 milliseconds
            // sessionCallback: myFunction, // function invoked for brand new connections or by a connection tag mismatch
            // sodaMetaDataCache: false, // Set true to improve SODA collection access performance
            // stmtCacheSize: 30, // number of statements that are cached in the statement cache of each connection
            // enableStatistics: false // record pool usage for oracledb.getPool().getStatistics() and logStatistics()
        })
        console.log('Connection pool started')
    } catch (err) {
        console.error('init() error: ' + err.message)
    }
}

async function testQuery() {
    let connection
    try {
        // Get a connection from the default pool
        connection = await oracledb.getConnection()
        const sql = `SELECT CURRENT_DATE FROM dual WHERE :b = 1`
        const binds = [1]
        const options = { outFormat: oracledb.OUT_FORMAT_OBJECT }
        const result = await connection.execute(sql, binds, options)
        console.log(result)
        // oracledb.getPool().logStatistics(); // show pool statistics.  pool.enableStatistics must be true
    } catch (err) {
        console.error(err)
    } finally {
        if (connection) {
            try {
                // Put the connection back in the pool
                await connection.close()
            } catch (err) {
                console.error(err)
            }
        }
    }
}

async function doQuery(sql) {
    let connection
    try {
        // Get a connection from the default pool
        connection = await oracledb.getConnection()
        const binds = []
        const options = { outFormat: oracledb.OUT_FORMAT_ARRAY }
        const result = await connection.execute(sql, binds, options)
        // console.log(result)
        // oracledb.getPool().logStatistics(); // show pool statistics.  pool.enableStatistics must be true
        return result
    } catch (err) {
        console.error(err)
    } finally {
        if (connection) {
            try {
                // Put the connection back in the pool
                await connection.close()
            } catch (err) {
                console.error(err)
            }
        }
    }
}



// https://node-oracledb.readthedocs.io/en/latest/user_guide/sql_execution.html#query-streaming
async function doQueryStream(sql) {
    let connection
    try {
        // Get a connection from the default pool
        connection = await oracledb.getConnection()
        // const binds = []
        // const options = { outFormat: oracledb.OUT_FORMAT_ARRAY }
        // const result = await connection.execute(sql, binds, options)
        const result = await connection.queryStream(sql)
        // console.log(result)
        // oracledb.getPool().logStatistics(); // show pool statistics.  pool.enableStatistics must be true
        return result
    } catch (err) {
        console.error(err)
        throw new Error(err)
    } finally {
        if (connection) {
            try {
                // Put the connection back in the pool
                await connection.close()
            } catch (err) {
                console.error(err)
            }
        }
    }
}

async function closePool() {
    console.log('\nTerminating')
    try {
        // Get the pool from the pool cache and close it when no
        // connections are in use, or force it closed after 10 seconds.
        // If this hangs, you may need DISABLE_OOB=ON in a sqlnet.ora file.
        // This setting should not be needed if both Oracle Client and Oracle
        // Database are 19c (or later).
        await oracledb.getPool().close(10)
        console.log('Pool closed')
        // process.exit(0)
    } catch (err) {
        console.error(err.message)
        // process.exit(1)
    }
}

async function getConnectionPool(dbConfig) {
    initOracleClient(dbConfig)
    process.once('SIGTERM', closePool).once('SIGINT', closePool)
    await init(dbConfig)
    return oracledb.getPool()
}

module.exports = {
    getConnectionPool,
    closePool,
    testQuery,
    doQuery,
    doQueryStream
}
