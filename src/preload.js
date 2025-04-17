const { contextBridge, ipcRenderer } = require('electron')
const { shell } = require('electron')
const path = require('path')
const { Part } = require('./Config')
const { Result } = require('./Target')
// const { selectDirectory } = require('./select-directory')

contextBridge.exposeInMainWorld('electronAPI', {
    setConfig: (message) => ipcRenderer.send('set-config', message),
    runExport: (message) => ipcRenderer.send('run-export', message),
    onConfig: (callback) => ipcRenderer.on('config', (event, data) => callback(data)),
    onDone: (callback) => ipcRenderer.on('done', (event, data) => callback(data)),
    onFailed: (callback) => ipcRenderer.on('failed', (event, data) => callback(data)),
    onPushFile: (callback) => ipcRenderer.on('push-file', (event, data) => callback(data)),
    openExternal: (uri) => shell.openExternal(uri),
    basename: (fileName) => path.basename(fileName),
    selectDirectory: (directoryPath) => ipcRenderer.send('select-directory', directoryPath),
    // selectDirectory: (directoryPath) => selectDirectory(directoryPath),
    part: Part,
    result: Result
});

window.addEventListener('DOMContentLoaded', () => {
    const replaceText = (selector, text) => {
        const element = document.getElementById(selector)
        if (element) element.innerText = text
    }

    for (const type of ['chrome', 'node', 'electron']) {
        replaceText(`${type}-version`, process.versions[type])
    }
})