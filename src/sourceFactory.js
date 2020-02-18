'use strict'

const Config = require('./Config')
const IsproSource = require('./ispro/IsproSource')
const C7Source = require('./c7/Source')

const makeSource = (config) => {
    if (config.source === Config.ISPRO)
        return new IsproSource()
    else if (config.source === Config.C7)
        return new C7Source()
    else
        throw 'Not implemented source.'
}

module.exports = makeSource