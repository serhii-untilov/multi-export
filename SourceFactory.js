'use strict'

const Config = require('./Config')
const Ispro = require('./ispro/Ispro')

const makeSource = (config) => {
    if (config.source === Config.ISPRO)
        return new Ispro(config)
    else
        throw 'Not implemented source.'
}

module.exports = makeSource