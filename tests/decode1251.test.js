const iconv = require('iconv-lite')

test('decode 1251 latin and cyrillic', () => {
    const src = 'abc123абв'
    const utf8 = iconv.encode(src, 'utf8')
    const cp1251 = iconv.encode(utf8, 'win1251')
    const result = iconv.decode(cp1251, 'win1251')
    console.log(utf8, cp1251, result)

    expect(result).toBe(src)
})
