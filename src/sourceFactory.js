'use strict'

const Config = require('./Config')
const IsproSource = require('./ISpro/SourceISpro')
const Source1C7 = require('./1C7/Source1C7')
const SourceParus = require('./Parus/SourceParus')
const SourceOsvita = require('./Osvita/SourceOsvita')

const makeSource = (config) => {
    if (config.source === Config.ISPRO) {
        return new IsproSource()
    } else if (config.source === Config.C7) {
        return new Source1C7()
    } else if (config.source === Config.PARUS) {
        return new SourceParus()
    } else if (config.source === Config.OSVITA) {
        return new SourceOsvita()
    } else {
        throw new Error('Not implemented source. You need to implement it.')
    }
}

module.exports = makeSource
