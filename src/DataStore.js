'use strict'

const Store = require('electron-store')
const Config = require('./Config')
const dotenv = require('dotenv')
dotenv.config()

class DataStore extends Store {
  constructor(settings) {
    console.log('1')
    super(settings)
    this.config = this.get('config') || _makeDefaultConfig()
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

function _makeDefaultConfig() {
  let config = new Config.Config()
  config.source = Config.HOME   // default source
  config.isArchive = true
  if (process.env.NODE_ENV == 'development') {
    // ispro DB connect
    config.server = process.env.SERVER
    config.login = process.env.LOGIN
    config.password = process.env.PASSWORD
    config.schema = process.env.SCHEMA
    config.schemaSys = process.env.SCHEMASYS
    console.log('Default config for development.', config)
  } else {
    config.targetPath = __dirname
    console.log('Default config for production.', config)
  }
  return config
}

module.exports = DataStore
