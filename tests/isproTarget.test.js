const sql = require('mssql')
const IsproTarget = require('../src/ispro/IsproTarget')

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
  let connectionString = target.makeConnectionString(config)
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

test.skip('Exec simple query', async () => {
  let target = new IsproTarget('testFileName')
  let config = {login: 'acc_qa', password: 'rsm2', server: '91.214.182.7,1403', schema: 'acc_qa'}
  let connectionString = target.makeConnectionString(config)
  await sql.connect(connectionString)
  const result = await sql.query('select cast(cast(getdate() as date) as varchar) as currentDate')
  const buffer = result.recordset[0].currentDate.substring(0,10)
  currentDateString = getCurrentDateString()
  expect(buffer).toBe(currentDateString)
})

test('Make file name', () => {
  let target = new IsproTarget('testFileName.sql')
  let config = {targetPath: 'X:\\'} 
  let fileName = target.makeFileName(config)
  expect(fileName).toBe('X:\\testFileName.csv')
})

test('Make file name without path.sep', () => {
  let target = new IsproTarget('testFileName.sql')
  let config = {targetPath: 'X:\\temp'} 
  let fileName = target.makeFileName(config)
  expect(fileName).toBe('X:\\temp\\testFileName.csv')
})