'use strict'

const Store = require('electron-store')
const Config = require('./Config')

class DataStore extends Store {
    constructor(settings) {
        super(settings)
        this.config = Object.assign(new Config.Config(), this.get('config'))
        this.config.source = this.config.source || Config.HOME // default source
    }

    saveConfig() {
        this.set('config', this.config)
        return this
    }

    getConfig() {
        return this.config
    }

    setConfig(config) {
        this.config = config
        this.saveConfig()
        return this
    }
}

module.exports = DataStore
