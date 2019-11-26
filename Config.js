'use strict'

const HOME  = 'home'
const ISPRO = 'ispro'
const AFINA = 'afina'
const PARUS = 'parus'
const C1 = '1C'

class Config {
    constructor() {
        // common data
        this.panel = this.ISPRO   // default panel
        this.path = ''
        this.isArchive = true

        // DB connect
        this.server = ''
        this.login = ''
        this.password = ''
        this.schema = ''

        // ispro only
        this.schemaSys = ''
        this.codeSE = ''
    }
}

module.exports = {
    Config,
    HOME,
    ISPRO,
    AFINA,
    PARUS,
    C1
}