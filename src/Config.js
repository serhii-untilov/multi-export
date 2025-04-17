'use strict'

const Part = {
    HOME: 'home',
    ISPRO: 'ispro',
    AFINA: 'afina',
    PARUS: 'parus',
    C7: 'C7',
    OSVITA: 'osvita',
    APK: 'APK',
    A5: 'A5',
    BOSSK: 'BOSSK',
}

const Version = {
    NO_TARIFFING: 0, // Без тарифікації (для департаменту освіти)
    TARIFFING: 1 // Тарифікація (для установ освіти)
}

const DBtype = {
    POSTGRES: 'Postgres',
    MSSQL: 'SQL Server',
    ORACLE: 'Oracle'
}

class Config {
    constructor() {
        // Params for targeted files
        this.source = Part.HOME // default source
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
        // + bossk
        this.orgCode = ''
        // + oracle
        this.dbType = 'SQL Server' // SQL Server, Postgres, Oracle
        this.oracleClient = '' // Oracle thick client lib local directory

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
        this.a5dbType = 'Postgres'
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
    Part,
    Version,
    DBtype
}
