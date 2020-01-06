'use strict'

const path = require('path')
const { app, ipcMain, dialog } = require('electron')
const Window = require('./src/Window')
const DataStore = require('./src/DataStore')
const makeSource = require('./src/SourceFactory')

require('electron-reload')(__dirname)

const dataStore = new DataStore({ name: 'multi-export-config' })

let mainWindow

function main() {

  mainWindow = new Window({
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

  const sendDone = () => {
    mainWindow.send('done')
  }

  const sendFailed = (err) => {
    mainWindow.send('failed', err)
  }

  ipcMain.on('run-export', (event, config) => {
    try {
      let source = makeSource(config)
      source.read(config, sendFile, sendDone, sendFailed)
    }
    catch (err) {
      mainWindow.send('failed', err)
    }
  })
}

app.on('ready', main)

app.on('window-all-closed', function () {
  app.quit()
})

async function selectDirectory() {
  let options = {
    title: "Виберіть каталог",
    defaultPath: "./",
    buttonLabel: "Вибрати",
    properties: ['openFile', 'multiSelections']
  }
  return await dialog.showOpenDialog(mainWindow, options)
}


module.exports = { selectDirectory }