'use strict'

const path = require('path')
const { app, ipcMain } = require('electron/main')
const Window = require('./src/Window')
const DataStore = require('./src/DataStore')
const makeSource = require('./src/sourceFactory')
const { selectDirectory } = require('./src/select-directory')
require('electron-reload')(__dirname)
const dataStore = new DataStore({ name: 'multi-export-config' })

function createWindow() {
    const win = new Window({
        _file: path.join('renderer', 'index.html'),
        get file() {
            return this._file
        },
        set file(value) {
            this._file = value
        }
    })

    win.loadFile('renderer/index.html')

    win.once('show', () => {
        const config = dataStore.getConfig()
        config.version = require('./package.json').version
        win.webContents.send('config', config)
    })

    ipcMain.on('set-config', (event, config) => {
        dataStore.setConfig(config)
    })

    ipcMain.on('select-directory', async (event, pathName) => {
        const config = dataStore.getConfig()
        const dialogResult = await selectDirectory(config[pathName])
        if (!dialogResult.canceled) {
            config[pathName] = dialogResult.filePaths[0]
            dataStore.setConfig(config)
            win.webContents.send('config', config)
        }
    })

    const targetList = []

    const sendFile = (target) => {
        const { fullFileName, state, err, recordsCount, append, sourceFullFileName } = target
        targetList.push({ fullFileName, state, err, recordsCount, append, sourceFullFileName })
        win.send('push-file', targetList)
    }

    const sendDone = (archiveName) => {
        win.send('done', archiveName)
    }

    const sendFailed = (err) => {
        win.send('failed', err)
    }

    ipcMain.on('run-export', (event, config) => {
        targetList.length = 0
        try {
            const source = makeSource(config)
            source.read(config, sendFile, sendDone, sendFailed)
        } catch (err) {
            win.send('failed', err)
        }
    })
}

// app.on('ready', main)
app.whenReady().then(() => {
    createWindow()

    app.on('activate', () => {
        if (BrowserWindow.getAllWindows().length === 0) {
            createWindow()
        }
    })
})

app.on('window-all-closed', function () {
    if (process.platform !== 'darwin') {
        app.quit()
    }
})
