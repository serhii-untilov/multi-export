const { Target } = require('../src/Target')

test('The Target must contain filled fileName field', () => {
    const target = new Target()
    expect(target.fullFileName).toBe(null)
})

test('The Target must contain state field which equal to null', () => {
    const target = new Target()
    expect(target.state).toBe(null)
})

test('The Target must contain err field which equal to null', () => {
    const target = new Target()
    expect(target.err).toBe(null)
})
