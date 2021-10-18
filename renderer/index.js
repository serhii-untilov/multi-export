'use strict'

const { ipcRenderer } = require('electron')
const { shell } = require('electron')
const path = require('path')
const Config = require('../src/Config')
const Target = require('../src/Target')

// For selectDirectory
const electron = require('electron')
const remote = electron.remote
const mainProcess = remote.require('./main')

const config = null

let targetList = []

let timeStart = null

const homePanel = document.getElementById('home-panel')
const isproPanel = document.getElementById('ispro-panel')
const afinaPanel = document.getElementById('afina-panel')
const parusPanel = document.getElementById('parus-panel')
const c1Panel = document.getElementById('c1-panel')
const osvitaPanel = document.getElementById('osvita-panel')
const apkPanel = document.getElementById('apk-panel')
const commonParamsPanel = document.getElementById('common-params-panel')
const controlPanel = document.getElementById('control-panel')
const resultPanel = document.getElementById('result-panel')
const resultToast = document.getElementById('result-toast')
const resultTable = document.getElementById('result-table')
const bodyPanel = document.getElementById('body-panel')
const footerPanel = document.getElementById('footer-panel')

const setVisible = (element, visible) => {
    const hide = 'd-hide'
    if (visible) {
        element.classList.remove(hide)
    } else {
        element.classList.remove(hide)
        element.classList.add(hide)
    }
}

const setSelected = (element, selected) => {
    const bold = 'bold'
    if (selected) {
        element.classList.remove(bold)
        element.classList.add(bold)
    } else {
        element.classList.remove(bold)
    }
}

const renderPanels = () => {
    setVisible(homePanel, !this.config || this.config.source === Config.HOME)
    setVisible(isproPanel, this.config && this.config.source === Config.ISPRO)
    setVisible(afinaPanel, this.config && this.config.source === Config.AFINA)
    setVisible(parusPanel, this.config && this.config.source === Config.PARUS)
    setVisible(c1Panel, this.config && this.config.source === Config.C7)
    setVisible(osvitaPanel, this.config && this.config.source === Config.OSVITA)
    setVisible(apkPanel, this.config && this.config.source === Config.APK)
    setVisible(commonParamsPanel, this.config && this.config.source !== Config.HOME)
    setVisible(controlPanel, this.config && this.config.source !== Config.HOME)
    setVisible(bodyPanel, false)
    setVisible(footerPanel, this.config && this.config.source === Config.HOME)
    setVisible(resultPanel, false)
}

const renderMenu = () => {
    if (!this.config) { return }
    setSelected(buttonSelectISPro, this.config.source === Config.ISPRO)
    setSelected(buttonSelectAfina, this.config.source === Config.AFINA)
    setSelected(buttonSelectParus, this.config.source === Config.PARUS)
    setSelected(buttonSelect1C, this.config.source === Config.C7)
    setSelected(buttonSelectOsvita, this.config.source === Config.OSVITA)
    setSelected(buttonSelectAPK, this.config.source === Config.APK)
}

const selectHome = () => {
    if (this.config.source === Config.HOME) { return }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = Config.HOME
    ipcRenderer.send('set-config', this.config)
    renderMenu()
    renderPanels()
}
document.getElementById('selectHome').addEventListener('click', selectHome)

const selectIspro = () => {
    if (this.config.source === Config.ISPRO) { return }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = Config.ISPRO
    ipcRenderer.send('set-config', this.config)
    renderMenu()
    renderPanels()
}
const buttonSelectISPro = document.getElementById('selectISPro')
buttonSelectISPro.addEventListener('click', selectIspro)
document.getElementById('homeSelectISPro').addEventListener('click', selectIspro)
document.getElementById('captionISPro').addEventListener('click', selectIspro)

const selectAfina = () => {
    if (this.config.source === Config.AFINA) { return }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = Config.AFINA
    ipcRenderer.send('set-config', this.config)
    renderMenu()
    renderPanels()
}
const buttonSelectAfina = document.getElementById('selectAfina')
buttonSelectAfina.addEventListener('click', selectAfina)
document.getElementById('homeSelectAfina').addEventListener('click', selectAfina)
document.getElementById('captionAfina').addEventListener('click', selectAfina)

const selectParus = () => {
    if (this.config.source === Config.PARUS) { return }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = Config.PARUS
    ipcRenderer.send('set-config', this.config)
    renderMenu()
    renderPanels()
}
const buttonSelectParus = document.getElementById('selectParus')
buttonSelectParus.addEventListener('click', selectParus)
document.getElementById('homeSelectParus').addEventListener('click', selectParus)
document.getElementById('captionParus').addEventListener('click', selectParus)

const select1C = () => {
    if (this.config.source === Config.C7) { return }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = Config.C7
    ipcRenderer.send('set-config', this.config)
    renderMenu()
    renderPanels()
}
const buttonSelect1C = document.getElementById('select1C')
buttonSelect1C.addEventListener('click', select1C)
document.getElementById('homeSelect1C').addEventListener('click', select1C)
document.getElementById('caption1C').addEventListener('click', select1C)

const selectOsvita = () => {
    if (this.config.source === Config.OSVITA) { return }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = Config.OSVITA
    ipcRenderer.send('set-config', this.config)
    renderMenu()
    renderPanels()
}
const buttonSelectOsvita = document.getElementById('selectOsvita')
buttonSelectOsvita.addEventListener('click', selectOsvita)
document.getElementById('homeSelectOsvita').addEventListener('click', selectOsvita)
document.getElementById('captionOsvita').addEventListener('click', selectOsvita)

const selectAPK = () => {
    if (this.config.source === Config.APK) { return }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = Config.APK
    ipcRenderer.send('set-config', this.config)
    renderMenu()
    renderPanels()
}
const buttonSelectAPK = document.getElementById('selectAPK')
buttonSelectAPK.addEventListener('click', selectAPK)
document.getElementById('homeSelectAPK').addEventListener('click', selectAPK)
document.getElementById('captionAPK').addEventListener('click', selectAPK)

document.getElementById('homeSelectA5').addEventListener('click', () => {
    shell.openExternal('https://a5buh.com')
})

document.getElementById('selectA5').addEventListener('click', () => {
    shell.openExternal('https://a5buh.com')
})

document.getElementById('selectGitHub').addEventListener('click', () => {
    shell.openExternal('https://github.com/sergey-untilov/multi-export')
})

const buttonRunExport = document.getElementById('run-export')
buttonRunExport.addEventListener('click', () => {
    timeStart = new Date()

    buttonRunExport.classList.remove('loading')
    buttonRunExport.classList.add('loading')

    setVisible(bodyPanel, true)
    targetList.length = 0
    ipcRenderer.send('run-export', this.config)

    resultToast.classList.remove('toast-error')
    resultToast.classList.remove('toast-warning')
    resultToast.classList.remove('toast-success')
    resultToast.classList.add('toast-warning')
    resultToast.innerHTML = 'Зачекайте, будь ласка. Виконується експорт.'
    setVisible(resultPanel, true)
})

const serverName = document.getElementById('server-name')
serverName.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.server = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

const login = document.getElementById('login')
login.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.login = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

const password = document.getElementById('password')
password.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.password = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

const schema = document.getElementById('org-schema-name')
schema.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.schema = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

const schemaSys = document.getElementById('sys-schema-name')
schemaSys.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.schemaSys = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

const codeSe = document.getElementById('code-se')
codeSe.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.codeSe = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

const codeDep = document.getElementById('code-dep')
codeDep.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.codeDep = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

const apkHost = document.getElementById('apk-host')
apkHost.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.apkHost = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

const apkLogin = document.getElementById('apk-login')
apkLogin.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.apkLogin = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

const apkPassword = document.getElementById('apk-password')
apkPassword.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.apkPassword = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

const apkDatabase = document.getElementById('apk-database')
apkDatabase.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.apkDatabase = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

const apkPort = document.getElementById('apk-port')
apkPort.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.apkPort = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

const afinaDbPath = document.getElementById('afina-db-path')
afinaDbPath.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.afinaDbPath = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

document.getElementById('select-afina-path').addEventListener('click', async () => {
    const dialogResult = await mainProcess.selectDirectory(this.config.afinaDbPath)
    if (!dialogResult.canceled) {
        afinaDbPath.value = dialogResult.filePaths[0]
        this.config.afinaDbPath = afinaDbPath.value
        ipcRenderer.send('set-config', this.config)
    }
})

const parusDbPath = document.getElementById('parus-db-path')
parusDbPath.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.parusDbPath = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

document.getElementById('select-parus-path').addEventListener('click', async () => {
    const dialogResult = await mainProcess.selectDirectory(this.config.parusDbPath)
    if (!dialogResult.canceled) {
        parusDbPath.value = dialogResult.filePaths[0]
        this.config.parusDbPath = parusDbPath.value
        ipcRenderer.send('set-config', this.config)
    }
})

const c1DbPath = document.getElementById('c1-db-path')
c1DbPath.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.c1DbPath = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

document.getElementById('select-c1-path').addEventListener('click', async () => {
    const dialogResult = await mainProcess.selectDirectory(this.config.c1DbPath)
    if (!dialogResult.canceled) {
        c1DbPath.value = dialogResult.filePaths[0]
        this.config.c1DbPath = c1DbPath.value
        ipcRenderer.send('set-config', this.config)
    }
})

const osvitaDbPath = document.getElementById('osvita-db-path')
osvitaDbPath.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.osvitaDbPath = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

document.getElementById('select-osvita-path').addEventListener('click', async () => {
    const dialogResult = await mainProcess.selectDirectory(this.config.osvitaDbPath)
    if (!dialogResult.canceled) {
        osvitaDbPath.value = dialogResult.filePaths[0]
        this.config.osvitaDbPath = osvitaDbPath.value
        ipcRenderer.send('set-config', this.config)
    }
})

const targetPath = document.getElementById('target-path')
targetPath.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.targetPath = evt.target.value
    ipcRenderer.send('set-config', this.config)
})

document.getElementById('select-target-path').addEventListener('click', async () => {
    const dialogResult = await mainProcess.selectDirectory(this.config.targetPath)
    if (!dialogResult.canceled) {
        targetPath.value = dialogResult.filePaths[0]
        this.config.targetPath = targetPath.value
        ipcRenderer.send('set-config', this.config)
    }
})

const isArchive = document.getElementById('isArchive')
isArchive.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.isArchive = evt.target.checked
    ipcRenderer.send('set-config', this.config)
})

ipcRenderer.on('config', (event, config) => {
    this.config = config || {}

    serverName.value = config.server || ''
    login.value = config.login || ''
    password.value = config.password || ''
    schema.value = config.schema || ''
    schemaSys.value = config.schemaSys || ''
    codeSe.value = config.codeSe || ''
    codeDep.value = config.codeDep || ''
    targetPath.value = config.targetPath || ''
    afinaDbPath.value = config.afinaDbPath || ''
    parusDbPath.value = config.parusDbPath || ''
    c1DbPath.value = config.c1DbPath || ''
    osvitaDbPath.value = config.osvitaDbPath || ''

    apkHost.value = config.apkHost || ''
    apkPort.value = config.apkPort || ''
    apkLogin.value = config.apkLogin || ''
    apkPassword.value = config.apkPassword || ''
    apkDatabase.value = config.apkDatabase || ''

    isArchive.checked = config.isArchive

    renderMenu()
    renderPanels()
})

renderMenu()
renderPanels()

const countErrors = (targetList) => {
    return targetList.reduce((a, b) => a + (b.err ? 1 : 0), 0)
}

const countCreated = (targetList) => {
    return targetList.reduce((a, b) => a + (b.state === Target.FILE_CREATED && !b.append ? 1 : 0), 0)
}

const pad = (num, size) => {
    let s = num + ''
    while (s.length < size) s = '0' + s
    return s
}

const stateText = (created, errors, arcFileName) => {
    let text = ''
    text = errors ? `Експорт виконано з помилками (${errors}).` : 'Експорт виконано успішно.'

    if (created) {
        text += ` Створено файлів: ${created}.`
    }

    if (arcFileName) {
        const fileName = path.basename(arcFileName)
        text += `<br />Запаковано у архівний файл "${fileName}".`
    }

    const timeFinish = new Date()
    const diff = timeFinish.getTime() - timeStart.getTime()
    const hours = pad(Math.round(diff / (1000 * 3600)), 2)
    const minutes = pad(Math.round(diff / (1000 * 60) % 60), 2)
    const seconds = pad(Math.round(diff / (1000) % 60), 2)
    text += `<br />Час виконання: ${hours}:${minutes}:${seconds}.`

    return text
}

ipcRenderer.on('done', (event, arcFileName) => {
    buttonRunExport.classList.remove('loading')

    resultToast.classList.remove('toast-error')
    resultToast.classList.remove('toast-warning')
    resultToast.classList.remove('toast-success')
    resultToast.classList.add('toast-success')
    resultToast.innerHTML = stateText(countCreated(targetList), countErrors(targetList), arcFileName)
    setVisible(resultPanel, true)
})

ipcRenderer.on('failed', (event, err) => {
    buttonRunExport.classList.remove('loading')

    resultToast.classList.remove('toast-success')
    resultToast.classList.remove('toast-error')
    resultToast.classList.remove('toast-warning')
    resultToast.classList.add('toast-error')
    resultToast.innerHTML = 'Експорт не виконано. ' + err
    resultTable.innerHTML = ''
    setVisible(bodyPanel, false)
    setVisible(resultPanel, true)
})

const getStateText = (target) => {
    switch (target.state) {
    case Target.FILE_CREATED: {
        const source = target.sourceFullFileName ? path.basename(target.sourceFullFileName) : ''
        if (source) {
            return target.append ? `Доповнено із ${source}` : `Створено із ${source}`
        }
        return target.append ? 'Файл доповнено' : 'Файл створено'
    }
    case Target.FILE_EMPTY: {
        const source = target.sourceFullFileName ? path.basename(target.sourceFullFileName) : ''
        if (target.append && source) {
            return target.append ? `Доповнено із ${source}` : `Створено із ${source}`
        }
        return 'Відсутні дані для експорту'
    }
    case Target.FILE_ERROR:
        console.log(target)
        return `Помилка. ${target.err}`
    default:
        return 'Невідома помилка'
    }
}

const renderGrid = () => {
    let html = ''
    for (let i = 0; i < targetList.length; i++) {
        const stateText = getStateText(targetList[i])
        const fileName = path.basename(targetList[i].fullFileName)
        html += `<tr><td>${fileName}</td><td>${stateText}</td></tr>`
    }
    resultTable.innerHTML = html
}

ipcRenderer.on('push-file', (event, _targetList) => {
    targetList = _targetList.slice(0)
    renderGrid()
})
