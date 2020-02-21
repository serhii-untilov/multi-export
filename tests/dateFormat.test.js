'use strict'

const dateFormat = require('../src/helper/dateFormat')

test('Test dateFormat', () => {
    let date = new Date('1980-12-31')

    expect(date.getFullYear()).toBe(1980)
    expect(date.getMonth() + 1).toBe(12)
    expect(date.getDate()).toBe(31)

    expect(dateFormat(date)).toEqual('1980-12-31')
    expect(dateFormat(0)).toEqual('')
    expect(dateFormat()).toEqual('')

    date = Date()
    expect(dateFormat(date)).toEqual('')
})
