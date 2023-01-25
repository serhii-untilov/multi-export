const iconv = require('iconv-lite')

test('decode 1251 latin and cyrillic', () => {
    const utf8 = 'abc123абв'
    const cp1251 = iconv.encode(utf8, 'win1251')
    const result = iconv.decode(cp1251, 'win1251')
    console.log(utf8, cp1251, result)

    expect(result).toBe(utf8)
})
