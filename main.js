'use strict'

const path = require('path')
const { app, ipcMain, dialog } = require('electron')
const Window = require('./src/Window')
const DataStore = require('./src/DataStore')
const makeSource = require('./src/sourceFactory')
require('electron-reload')(__dirname)
const dataStore = new DataStore({ name: 'multi-export-config' })

function main() {
    const mainWindow = new Window({
        _file: path.join('renderer', 'index.html'),
        get file() {
            return this._file
        },
        set file(value) {
            this._file = value
        }
    })

    mainWindow.once('show', () => {
        const config = dataStore.getConfig()
        config.version = require('./package.json').version
        mainWindow.webContents.send('config', config)
    })

    ipcMain.on('set-config', (event, config) => {
        dataStore.setConfig(config)
    })

    const targetList = []

    const sendFile = (target) => {
        const { fullFileName, state, err, recordsCount, append, sourceFullFileName } = target
        targetList.push({ fullFileName, state, err, recordsCount, append, sourceFullFileName })
        mainWindow.send('push-file', targetList)
    }

    const sendDone = (archiveName) => {
        mainWindow.send('done', archiveName)
    }

    const sendFailed = (err) => {
        mainWindow.send('failed', err)
    }

    ipcMain.on('run-export', (event, config) => {
        targetList.length = 0
        try {
            const source = makeSource(config)
            source.read(config, sendFile, sendDone, sendFailed)
        } catch (err) {
            mainWindow.send('failed', err)
        }
    })
}

app.on('ready', main)

app.on('window-all-closed', function () {
    app.quit()
})

async function selectDirectory(defaultPath) {
    const options = {
        title: 'Виберіть каталог',
        defaultPath: defaultPath,
        buttonLabel: 'Вибрати',
        properties: ['openDirectory', 'promptToCreate']
    }
    // return await dialog.showOpenDialog(mainWindow, options) !!! Doesn't select a directory, only file
    return await dialog.showOpenDialog(options)
}

module.exports = { selectDirectory }
