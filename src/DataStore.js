'use strict'

const Store = require('electron-store')
const { Config, Part } = require('./Config')

class DataStore extends Store {
    constructor(settings) {
        super(settings)
        this.config = Object.assign(new Config(), this.get('config'))
        this.config.source = this.config.source || Part.HOME // default source
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
