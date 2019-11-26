'use strict'

const path = require('path')
const { app, ipcMain } = require('electron')

const Window = require('./Window')
const DataStore = require('./DataStore')

require('electron-reload')(__dirname)

// create a new config store name "Multi Export Config"
const dataStore = new DataStore({ name: 'multi-export-config' })

let fileList = []

const pushFile = (fileList, fileName) => {
  fileList.push(fileName)
}

function main () {

  let mainWindow = new Window({
    file: path.join('renderer', 'index.html')
  })

  mainWindow.once('show', () => {
    mainWindow.webContents.send('config', dataStore.getConfig())
  })

  ipcMain.on('set-config', (event, config) => {
    console.log('set-config', config)
    dataStore.setConfig(config)
  })

  ipcMain.on('run-export', () => {
    fileList = []
    for (var i = 0; i < 10; i++) {
      pushFile(fileList, 'File ' + i.toString())
      mainWindow.send('push-file', fileList)
    }
    mainWindow.send('done', fileList)    
  })
}

app.on('ready', main)

app.on('window-all-closed', function () {
  app.quit()
})
