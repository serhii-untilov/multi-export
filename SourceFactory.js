'use strict'

const { Config } = require('./Config')
const Ispro = require('./ispro/Ispro')

const makeSource = (config) => {
    switch(config.panel) {
        case Config.ISPRO:
            return new Ispro()
        default:
            throw 'Not implemented source.'
    }
}

module.exports = makeSource