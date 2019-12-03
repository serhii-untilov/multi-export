'use strict'

const Config = require('./Config')
const IsproSource = require('./ispro/IsproSource')

const makeSource = (config) => {
    if (config.source === Config.ISPRO)
        return new IsproSource()
    else
        throw 'Not implemented source.'
}

module.exports = makeSource