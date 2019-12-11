'use strict'

const path = require('path')
const { app, ipcMain } = require('electron')
const Window = require('./src/Window')
const DataStore = require('./src/DataStore')
const makeSource = require('./src/SourceFactory')
const ArchiveMaker = require('./src/ArchiveMaker')

require('electron-reload')(__dirname)

const dataStore = new DataStore({ name: 'multi-export-config' })

let targetList = []

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

  const sendFile = (target) => {
    targetList.push(target)
    mainWindow.send('push-file', targetList)
  }

  const sendDone = () => {
    mainWindow.send('done', targetList)
  }

  ipcMain.on('run-export', (event, config) => {
    targetList = []
    try {
      let source = makeSource(config)
      source.read(config, sendFile, sendDone)
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
