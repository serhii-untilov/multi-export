'use strict'

const fs = require('fs')

const SQL_FILES_DIR = './assets/ispro'

test.only('Test readdirSync', () => {
    let fileList = fs.readdirSync(SQL_FILES_DIR)
    expect(fileList.length > 0).toBe(true)
})