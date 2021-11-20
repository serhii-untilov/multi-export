function decodeIPN (ipn) {
    if (ipn.length !== 10) { return {} }
    const days = parseInt(ipn.substring(0, 5))
    const birthDate = new Date('1899-12-31')
    birthDate.setDate(birthDate.getDate() + days)
    const sex = parseInt(ipn.substring(8, 9)) % 2 ? 'W' : 'M'
    return { birthDate, sex }
}

module.exports = decodeIPN
