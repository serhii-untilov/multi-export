const fs = require('fs')
const IsproTarget = require('../ispro/IsproTarget')

function sum(a, b) {
    return a + b;
  }

test('adds 1 + 2 to equal 3', () => {
    expect(sum(1, 2)).toBe(3);
  });

test('isproTarget get fileDescription', () => {
    let isproTarget = new IsproTarget(null)
    expect(isproTarget.fileDescription('-- Тест (test)')).toBe('Тест');
  });

  test('ispro__ac_bank.sql exists', () => {
    console.log('__dirname', __dirname)
    let fileExists = false
    // fs.access('../assets/ispro/ispro__ac_bank.sql', fs.constants.F_OK, (err) => {
    fs.access('isproTarget.test.js', fs.constants.F_OK, (err) => {
      fileExists = err ? false : true
    })
    expect(fileExists).toBe(true);
  })

  test('isproTarget get fileDescription for Bank file', () => {
    let isproTarget = new IsproTarget(null)
    content = isproTarget.fileContent('./assets/ispro/ispro__ac_bank.sql')
    expect(isproTarget.fileDescription(content)).toBe('Банки');
  });  