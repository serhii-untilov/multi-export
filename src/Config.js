'use strict'

const HOME = 'home'
const ISPRO = 'ispro'
const AFINA = 'afina'
const PARUS = 'parus'
const C7 = 'C7'
const OSVITA = 'osvita'
const APK = 'APK'

class Config {
    constructor () {
        // Params for targeted files
        this.source = this.HOME // default source
        this.targetPath = ''
        this.isArchive = true

        // ispro DB connect
        this.server = ''
        this.login = ''
        this.password = ''
        this.schema = ''
        this.schemaSys = ''
        this.codeSe = ''
        this.codeDep = ''

        // Source DB path
        this.afinaDbPath = ''
        this.parusDbPath = ''
        this.c1DbPath = ''
        this.osvitaDbPath = ''

        // APK DB connect
        this.APK.host = 'localhost'
        this.APK.port = '5433'
        this.APK.login = 'test'
        this.APK.password = 'test'
        this.APK.database = 'test'
    }
}

module.exports = {
    Config,
    HOME,
    ISPRO,
    AFINA,
    PARUS,
    C7,
    OSVITA,
    APK
}
