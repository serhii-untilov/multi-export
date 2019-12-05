const sql = require('mssql')
const IsproTarget = require('../src/ispro/IsproTarget')
const dotenv = require('dotenv')
dotenv.config()

test('The Target must contain filled fileName field', () => {
  let target = new IsproTarget('testFileName')
  expect(target.fileName).toBe('testFileName')
})

test('The Target must contain state field which equal to null', () => {
  let target = new IsproTarget('testFileName')
  expect(target.state).toBe(null)
})

test('The Target must contain err field which equal to null', () => {
  let target = new IsproTarget('testFileName')
  expect(target.err).toBe(null)
})

test('Make a connection string', () => {
  let target = new IsproTarget('testFileName')
  let config = {login: 'login', password: 'password', server: 'server', schema: 'schema'}
  let connectionString = target.getConnectionString(config)
  expect(connectionString).toBe('mssql://login:password@server/schema')
})

const getCurrentDateString = () => {
  var today = new Date()
  var dd = String(today.getDate()).padStart(2, '0')
  var mm = String(today.getMonth() + 1).padStart(2, '0')
  var yyyy = today.getFullYear()
  today = yyyy + '-' + mm + '-' + dd
  return today
}

test('Check environment variables initialized from .env file', () => {
  // See README.md, Environment variables section
  expect(process.env.server).not.toBe(undefined) 
  expect(process.env.login).not.toBe(undefined) 
  expect(process.env.password).not.toBe(undefined) 
  expect(process.env.schema).not.toBe(undefined) 
  // expect(process.env.schemasys).not.toBe(undefined) 
})

test('Exec a simple query', async () => {
  // See README.md, Environment variables section
  let config = {
    server: process.env.server, 
    login: process.env.login, 
    password: process.env.password, 
    schema: process.env.schema,
    // schemaSys: process.env.schemasys
  }
  let target = new IsproTarget('testFileName')
  let connectionString = target.getConnectionString(config)
  const recordset = await target.doQuery(connectionString, 'select cast(cast(getdate() as date) as varchar) as currentDate')
  const buffer = recordset[0].currentDate.substring(0,10)
  currentDateString = getCurrentDateString()
  expect(buffer).toBe(currentDateString)
})

test('Make file name', () => {
  let target = new IsproTarget('testFileName.sql')
  let config = {targetPath: 'X:\\'} 
  let fileName = target.getTargetFileName(config)
  expect(fileName).toBe('X:\\testFileName.csv')
})

test('Make file name without path.sep', () => {
  let target = new IsproTarget('testFileName.sql')
  let config = {targetPath: 'X:\\temp'} 
  let fileName = target.getTargetFileName(config)
  expect(fileName).toBe('X:\\temp\\testFileName.csv')
})

