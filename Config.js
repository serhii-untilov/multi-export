'use strict'

const HOME  = 'home'
const ISPRO = 'ispro'
const AFINA = 'afina'
const PARUS = 'parus'
const C1 = '1C'

class Config {
    constructor() {
        // Params for targeted files
        this.panel = this.ISPRO   // default panel
        this.targetPath = ''
        this.isArchive = true

        // ispro DB connect
        this.server = ''
        this.login = ''
        this.password = ''
        this.schema = ''
        this.schemaSys = ''
        this.codeSe = ''

        // Source DB path
        this.afinaDbPath = ''
        this.parusDbPath = ''
        this.c1DbPath = ''
    }
}

module.exports = {
    Config,
    HOME,
    ISPRO,
    AFINA,
    PARUS,
    C1,
}