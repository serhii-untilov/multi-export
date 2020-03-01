'use strict'

const Config = require('./Config')
const IsproSource = require('./ISpro/SourceISpro')
const Source1C7 = require('./1C7/Source1C7')

const makeSource = (config) => {
    if (config.source === Config.ISPRO)
        return new IsproSource()
    else if (config.source === Config.C7)
        return new Source1C7()
    else
        throw 'Not implemented source.'
}

module.exports = makeSource