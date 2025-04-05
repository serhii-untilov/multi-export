'use strict'

const HOME = 'home'
const ISPRO = 'ispro'
const AFINA = 'afina'
const PARUS = 'parus'
const C7 = 'C7'
const OSVITA = 'osvita'
const APK = 'APK'
const A5 = 'A5'
const BOSSK = 'BOSSK'

const Version = {
    NO_TARIFFING: 0, // Без тарифікації (для департаменту освіти)
    TARIFFING: 1 // Тарифікація (для установ освіти)
}

const DBtype = {
    POSTGRES: 0,
    MSSQL: 1
}

class Config {
    constructor() {
        // Params for targeted files
        this.source = this.HOME // default source
        this.targetPath = ''
        this.isArchive = true

        // DB connect (ispro, bossk)
        this.domain = ''
        this.server = ''
        this.port = ''
        this.login = ''
        this.password = ''
        this.schema = ''
        // + ispro
        this.schemaSys = ''
        this.codeSe = ''
        this.codeDep = ''
        this.dbType = ''
        // + bossk
        this.orgCode = ''

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

        // A5 DB connect
        this.a5dbType = ''
        this.a5Host = 'localhost'
        this.a5Port = '5433'
        this.a5Login = ''
        this.a5Password = ''
        this.a5Database = ''
        this.a5orgCode = ''
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
    APK,
    A5,
    BOSSK,
    DBtype
}
