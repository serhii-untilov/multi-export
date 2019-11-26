'use strict'

const Store = require('electron-store')
const {Config} = require('./Config')

class DataStore extends Store {
  constructor (settings) {
    super(settings)
    this.config = this.get('config') || new Config()
  }

  saveConfig () {
    console.log('saveConfig', this.config)
    this.set('config', this.config)
    // returning 'this' allows method chaining
    return this
  }

  getConfig () {
    // set object's in JSON file
    // this.config = this.get('config') || new Config()
    return this.config
  }

  setConfig (config) {
    //console.log('setConfig', config)
    this.config = config
    this.saveConfig()
    return this
  }

  clearConfig() {
    this.config = new Config()
    this.saveConfig()
    return this
  }
}

module.exports = DataStore
