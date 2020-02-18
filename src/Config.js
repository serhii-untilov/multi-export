'use strict'

const HOME  = 'home'
const ISPRO = 'ispro'
const AFINA = 'afina'
const PARUS = 'parus'
const C7 = 'C7'

class Config {
    constructor() {
        // Params for targeted files
        this.source = this.HOME   // default source
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
    C7
}