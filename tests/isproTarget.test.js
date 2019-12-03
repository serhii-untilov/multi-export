const IsproTarget = require('../ispro/IsproTarget')

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