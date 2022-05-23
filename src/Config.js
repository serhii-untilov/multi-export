'use strict'

const HOME = 'home'
const ISPRO = 'ispro'
const AFINA = 'afina'
const PARUS = 'parus'
const C7 = 'C7'
const OSVITA = 'osvita'
const APK = 'APK'

const Version = {
    NO_TARIFFING: 0, // Без тарифікації (для департаменту освіти)
    TARIFFING: 1 // Тарифікація (для установ освіти)
}

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
        this.osvitaBaseDate = ''
        this.osvitaVersion = ''
        this.osvitaOrganization = ''
        this.osvitaDepartment = ''

        // APK DB connect
        this.apkHost = 'localhost'
        this.apkPort = '5433'
        this.apkLogin = 'test'
        this.apkPassword = 'test'
        this.apkDatabase = 'test'
    }
}

module.exports = {
    Config,
    Version,
    HOME,
    ISPRO,
    AFINA,
    PARUS,
    C7,
    OSVITA,
    APK
}
