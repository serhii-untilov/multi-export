'use strict'

const { Part } = require('./Config')
const IsproSource = require('./ISpro/SourceISpro')
const IsproSourceOracle = require('./ISproOracle/SourceISproOracle')
const Source1C7 = require('./1C7/Source1C7')
const SourceParus = require('./Parus/SourceParus')
const SourceOsvita = require('./Osvita/SourceOsvita')
const SourceAPK = require('./APK/SourceAPK')
const SourceA5 = require('./A5/SourceA5')
const SourceBossk = require('./Bossk/SourceBossk')

const makeSource = (config) => {
    if (config.source === Part.ISPRO) {
        if (config.dbType === 'Oracle') {
            return new IsproSourceOracle()
        }
        return new IsproSource()
    } else if (config.source === Part.C7) {
        return new Source1C7()
    } else if (config.source === Part.PARUS) {
        return new SourceParus()
    } else if (config.source === Part.OSVITA) {
        return new SourceOsvita()
    } else if (config.source === Part.APK) {
        return new SourceAPK()
    } else if (config.source === Part.A5) {
        return new SourceA5()
    } else if (config.source === Part.BOSSK) {
        return new SourceBossk()
    } else {
        throw new Error('Not implemented source. You need to implement it.')
    }
}

module.exports = makeSource
