'use strict'

const path = require('path')
const { app, ipcMain } = require('electron')
const Window = require('./Window')
const DataStore = require('./DataStore')
const makeSource = require('./SourceFactory')

require('electron-reload')(__dirname)

const dataStore = new DataStore({ name: 'multi-export-config' })

function main() {

  let mainWindow = new Window({
    file: path.join('renderer', 'index.html')
  })

  mainWindow.once('show', () => {
    mainWindow.webContents.send('config', dataStore.getConfig())
  })

  ipcMain.on('set-config', (event, config) => {
    dataStore.setConfig(config)
  })

  ipcMain.on('run-export', (event, config) => {
    let fileList = []
    try {
      let source = makeSource(config)
      source.read(function (target) {
        fileList.push(target)
        mainWindow.send('push-file', fileList)
      })
      mainWindow.send('done', fileList)
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
