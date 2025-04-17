'use strict'

const { BrowserWindow, Menu } = require('electron/main')
const path = require('path')

// default window settings
const defaultProps = {
    width: 840,
    height: 740,
    show: false,

    // update for electron V5+
    webPreferences: {
        nodeIntegration: true,
        // update for electron V12+
        // contextIsolation: true,
        // enableRemoteModule: true,
        // nodeIntegrationInWorker: true,
        // webviewTag: true
        preload: path.join(__dirname, 'preload.js')
    }
}

class Window extends BrowserWindow {
    constructor({ file, ...windowSettings }) {
        // calls new BrowserWindow with these props
        super({ ...defaultProps, ...windowSettings })

        // load the html and open devtools
        this.loadFile(file)
        // this.webContents.openDevTools()

        // gracefully show when ready to prevent flickering
        this.once('ready-to-show', () => {
            this.show()
        })

        Menu.setApplicationMenu(null)
    }
}

module.exports = Window;
