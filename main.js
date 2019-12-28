'use strict'

const path = require('path')
const { app, ipcMain } = require('electron')
const Window = require('./src/Window')
const DataStore = require('./src/DataStore')
const makeSource = require('./src/SourceFactory')
const ArchiveMaker = require('./src/ArchiveMaker')

require('electron-reload')(__dirname)

const dataStore = new DataStore({ name: 'multi-export-config' })

function main() {

  let mainWindow = new Window({
    _file: path.join('renderer', 'index.html'),
    get file() {
      return this._file
    },
    set file(value) {
      this._file = value
    },
  })

  mainWindow.once('show', () => {
    mainWindow.webContents.send('config', dataStore.getConfig())
  })

  ipcMain.on('set-config', (event, config) => {
    dataStore.setConfig(config)
  })

  const sendFile = (target) => {
    mainWindow.send('push-file', target)
  }

  ipcMain.on('run-export', (event, config) => {
    try {
      let source = makeSource(config)
      source.read(config, sendFile)
      mainWindow.send('done')
    }
    catch (err) {
      console.log(err)
      mainWindow.send('failed', err)
    }
  })
}

app.on('ready', main)

app.on('window-all-closed', function () {
  app.quit()
})
