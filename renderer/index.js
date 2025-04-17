// const { ipcRenderer } = require('electron')
// const { shell } = require('electron')
// const path = require('path')
// const Config = require('../src/Config')
// const Target = require('../src/Target')

// For selectDirectory
// const electron = require('electron')
// const remote = electron.remote
// const mainProcess = remote.require('./main')

this.config = null

let targetList = []

let timeStart = null

const homePanel = document.getElementById('home-panel')
const isproPanel = document.getElementById('ispro-panel')
const afinaPanel = document.getElementById('afina-panel')
const parusPanel = document.getElementById('parus-panel')
const c1Panel = document.getElementById('c1-panel')
const osvitaPanel = document.getElementById('osvita-panel')
const apkPanel = document.getElementById('apk-panel')
const a5Panel = document.getElementById('a5-panel')
const bosskPanel = document.getElementById('bossk-panel')
const commonParamsPanel = document.getElementById('common-params-panel')
const controlPanel = document.getElementById('control-panel')
const resultPanel = document.getElementById('result-panel')
const resultToast = document.getElementById('result-toast')
const resultTable = document.getElementById('result-table')
const bodyPanel = document.getElementById('body-panel')
const footerPanel = document.getElementById('footer-panel')
const oracleClientPanel = document.getElementById('oracle-client-panel')

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
    setVisible(homePanel, !this.config || this.config.source === window.electronAPI.part.HOME)
    setVisible(isproPanel, this.config && this.config.source === window.electronAPI.part.ISPRO)
    setVisible(afinaPanel, this.config && this.config.source === window.electronAPI.part.AFINA)
    setVisible(oracleClientPanel, this.config && this.config.source === window.electronAPI.part.ISPRO && this.config.dbType === 'Oracle')
    setVisible(parusPanel, this.config && this.config.source === window.electronAPI.part.PARUS)
    setVisible(c1Panel, this.config && this.config.source === window.electronAPI.part.C7)
    setVisible(osvitaPanel, this.config && this.config.source === window.electronAPI.part.OSVITA)
    setVisible(apkPanel, this.config && this.config.source === window.electronAPI.part.APK)
    setVisible(a5Panel, this.config && this.config.source === window.electronAPI.part.A5)
    setVisible(bosskPanel, this.config && this.config.source === window.electronAPI.part.BOSSK)
    setVisible(commonParamsPanel, this.config && this.config.source !== window.electronAPI.part.HOME)
    setVisible(controlPanel, this.config && this.config.source !== window.electronAPI.part.HOME)
    setVisible(bodyPanel, false)
    setVisible(footerPanel, this.config && this.config.source === window.electronAPI.part.HOME)
    setVisible(resultPanel, false)
    setVisible(osvitaOrganization, osvitaVersion.selectedIndex === 0)
    setVisible(osvitaOrganizationLabel, osvitaVersion.selectedIndex === 0)
    setVisible(osvitaDepartment, osvitaVersion.selectedIndex === 0)
    setVisible(osvitaDepartmentLabel, osvitaVersion.selectedIndex === 0)
}

const renderMenu = () => {
    if (!this.config) {
        return
    }
    setSelected(buttonSelectISPro, this.config.source === window.electronAPI.part.ISPRO)
    setSelected(buttonSelectAfina, this.config.source === window.electronAPI.part.AFINA)
    setSelected(buttonSelectParus, this.config.source === window.electronAPI.part.PARUS)
    setSelected(buttonSelect1C, this.config.source === window.electronAPI.part.C7)
    setSelected(buttonSelectOsvita, this.config.source === window.electronAPI.part.OSVITA)
    setSelected(buttonSelectAPK, this.config.source === window.electronAPI.part.APK)
    setSelected(buttonSelectA5, this.config.source === window.electronAPI.part.A5)
    setSelected(buttonSelectBossk, this.config.source === window.electronAPI.part.BOSSK)

    setVisible(buttonSelect1C, false)
    setVisible(buttonSelectAfina, false)
    setVisible(buttonSelectParus, false)
    setVisible(part1C, false)
    setVisible(partAfina, false)
    setVisible(partParus, false)
}

const selectHome = () => {
    if (this.config.source === window.electronAPI.part.HOME) {
        return
    }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = window.electronAPI.part.HOME
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
    renderMenu()
    renderPanels()
}
document.getElementById('selectHome').addEventListener('click', selectHome)

const selectIspro = () => {
    if (this.config.source === window.electronAPI.part.ISPRO) {
        return
    }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = window.electronAPI.part.ISPRO
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
    renderMenu()
    renderPanels()
}
const buttonSelectISPro = document.getElementById('selectISPro')
buttonSelectISPro.addEventListener('click', selectIspro)
document.getElementById('homeSelectISPro').addEventListener('click', selectIspro)
document.getElementById('captionISPro').addEventListener('click', selectIspro)

const oracleClient = document.getElementById('oracle-client')
oracleClient.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.oracleClient = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

document.getElementById('select-oracle-client').addEventListener('click', async () => {
    // const dialogResult = await mainProcess.selectDirectory(this.config.oracleClient)
    // const dialogResult = await window.electronAPI.selectDirectory(this.config.oracleClient)
    // if (!dialogResult.canceled) {
    //     oracleClient.value = dialogResult.filePaths[0]
    //     this.config.oracleClient = oracleClient.value
    //     // ipcRenderer.send('set-config', this.config)
    //     window.electronAPI.setConfig(this.config)
    // }
    window.electronAPI.selectDirectory('oracleClient')
})

const selectBossk = () => {
    if (this.config.source === window.electronAPI.part.BOSSK) {
        return
    }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = window.electronAPI.part.BOSSK
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
    renderMenu()
    renderPanels()
}
const buttonSelectBossk = document.getElementById('selectBossk')
buttonSelectBossk.addEventListener('click', selectBossk)
document.getElementById('homeSelectBossk').addEventListener('click', selectBossk)
document.getElementById('captionBossk').addEventListener('click', selectBossk)

const selectAfina = () => {
    if (this.config.source === window.electronAPI.part.AFINA) {
        return
    }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = window.electronAPI.part.AFINA
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
    renderMenu()
    renderPanels()
}
const buttonSelectAfina = document.getElementById('selectAfina')
buttonSelectAfina.addEventListener('click', selectAfina)
document.getElementById('homeSelectAfina').addEventListener('click', selectAfina)
document.getElementById('captionAfina').addEventListener('click', selectAfina)
const partAfina = document.getElementById('partAfina')

const selectParus = () => {
    if (this.config.source === window.electronAPI.part.PARUS) {
        return
    }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = window.electronAPI.part.PARUS
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
    renderMenu()
    renderPanels()
}
const buttonSelectParus = document.getElementById('selectParus')
buttonSelectParus.addEventListener('click', selectParus)
document.getElementById('homeSelectParus').addEventListener('click', selectParus)
document.getElementById('captionParus').addEventListener('click', selectParus)
const partParus = document.getElementById('partParus')

const select1C = () => {
    if (this.config.source === window.electronAPI.part.C7) {
        return
    }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = window.electronAPI.part.C7
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
    renderMenu()
    renderPanels()
}
const buttonSelect1C = document.getElementById('select1C')
buttonSelect1C.addEventListener('click', select1C)
document.getElementById('homeSelect1C').addEventListener('click', select1C)
document.getElementById('caption1C').addEventListener('click', select1C)
const part1C = document.getElementById('part1C')

const selectOsvita = () => {
    if (this.config.source === window.electronAPI.part.OSVITA) {
        return
    }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = window.electronAPI.part.OSVITA
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
    renderMenu()
    renderPanels()
}
const buttonSelectOsvita = document.getElementById('selectOsvita')
buttonSelectOsvita.addEventListener('click', selectOsvita)
document.getElementById('homeSelectOsvita').addEventListener('click', selectOsvita)
document.getElementById('captionOsvita').addEventListener('click', selectOsvita)

const selectAPK = () => {
    if (this.config.source === window.electronAPI.part.APK) {
        return
    }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = window.electronAPI.part.APK
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
    renderMenu()
    renderPanels()
}
const buttonSelectAPK = document.getElementById('selectAPK')
buttonSelectAPK.addEventListener('click', selectAPK)
document.getElementById('homeSelectAPK').addEventListener('click', selectAPK)
document.getElementById('captionAPK').addEventListener('click', selectAPK)

const selectA5 = () => {
    if (this.config.source === window.electronAPI.part.A5) {
        return
    }
    buttonRunExport.classList.remove('loading')
    targetList.length = 0
    this.config.source = window.electronAPI.part.A5
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
    renderMenu()
    renderPanels()
}
const buttonSelectA5 = document.getElementById('selectA5')
buttonSelectA5.addEventListener('click', selectA5)
document.getElementById('homeSelectA5').addEventListener('click', selectA5)
document.getElementById('captionA5').addEventListener('click', selectA5)

document.getElementById('linkHomeA5').addEventListener('click', () => {
    // shell.openExternal('https://a5erp.solutions/')
    window.electronAPI.openExternal('https://a5erp.solutions/')
})

document.getElementById('goHomeA5').addEventListener('click', () => {
    // shell.openExternal('https://a5erp.solutions/')
    window.electronAPI.openExternal('https://a5erp.solutions/')
})

document.getElementById('goGitHub').addEventListener('click', () => {
    // shell.openExternal('https://www.untilov.com.ua/')
    window.electronAPI.openExternal('https://www.untilov.com.ua/')
})

const buttonRunExport = document.getElementById('run-export')
buttonRunExport.addEventListener('click', () => {
    timeStart = new Date()

    buttonRunExport.classList.remove('loading')
    buttonRunExport.classList.add('loading')

    setVisible(bodyPanel, true)
    targetList.length = 0
    // ipcRenderer.send('run-export', this.config)
    window.electronAPI.runExport(this.config)

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
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const login = document.getElementById('login')
login.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.login = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const password = document.getElementById('password')
password.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.password = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const schema = document.getElementById('org-schema-name')
schema.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.schema = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const schemaSys = document.getElementById('sys-schema-name')
schemaSys.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.schemaSys = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const codeSe = document.getElementById('code-se')
codeSe.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.codeSe = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

// const codeDep = document.getElementById('code-dep')
// codeDep.addEventListener('change', (evt) => {
//     evt.preventDefault()
//     this.config.codeDep = evt.target.value
//     // ipcRenderer.send('set-config', this.config)
//     window.electronAPI.setConfig(this.config)
// })

const dbType = document.getElementById('db-type')
dbType.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.dbType = evt.target.value // selectedIndex // value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
    setVisible(oracleClientPanel, this.config.dbType === 'Oracle')
})

const bosskDomain = document.getElementById('bk-domain')
bosskDomain.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.domain = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const bosskServerName = document.getElementById('bk-server-name')
bosskServerName.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.server = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const bosskPort = document.getElementById('bk-port')
bosskPort.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.port = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const bosskLogin = document.getElementById('bk-login')
bosskLogin.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.login = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const bosskPassword = document.getElementById('bk-password')
bosskPassword.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.password = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const bosskSchema = document.getElementById('bk-schema-name')
bosskSchema.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.schema = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const bosskOrgCode = document.getElementById('bk-org-code')
bosskOrgCode.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.orgCode = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const apkHost = document.getElementById('apk-host')
apkHost.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.apkHost = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const apkLogin = document.getElementById('apk-login')
apkLogin.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.apkLogin = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const apkPassword = document.getElementById('apk-password')
apkPassword.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.apkPassword = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const apkDatabase = document.getElementById('apk-database')
apkDatabase.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.apkDatabase = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const apkPort = document.getElementById('apk-port')
apkPort.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.apkPort = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const a5dbType = document.getElementById('a5-db-type')
a5dbType.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.a5dbType = evt.target.value // selectedIndex // value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const a5Host = document.getElementById('a5-host')
a5Host.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.a5Host = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const a5Login = document.getElementById('a5-login')
a5Login.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.a5Login = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const a5Password = document.getElementById('a5-password')
a5Password.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.a5Password = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const a5Database = document.getElementById('a5-database')
a5Database.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.a5Database = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const a5orgCode = document.getElementById('a5-org-code')
a5orgCode.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.a5orgCode = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const a5Port = document.getElementById('a5-port')
a5Port.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.a5Port = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const afinaDbPath = document.getElementById('afina-db-path')
afinaDbPath.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.afinaDbPath = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

document.getElementById('select-afina-path').addEventListener('click', async () => {
    // const dialogResult = await mainProcess.selectDirectory(this.config.afinaDbPath)
    // const dialogResult = await window.electronAPI.selectDirectory(this.config.afinaDbPath)
    // if (!dialogResult.canceled) {
    //     afinaDbPath.value = dialogResult.filePaths[0]
    //     this.config.afinaDbPath = afinaDbPath.value
    //     // ipcRenderer.send('set-config', this.config)
    //     window.electronAPI.setConfig(this.config)
    // }
    window.electronAPI.selectDirectory('afinaDbPath')
})

const parusDbPath = document.getElementById('parus-db-path')
parusDbPath.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.parusDbPath = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

document.getElementById('select-parus-path').addEventListener('click', async () => {
    // const dialogResult = await mainProcess.selectDirectory(this.config.parusDbPath)
    // const dialogResult = await window.electronAPI.selectDirectory(this.config.parusDbPath)
    // if (!dialogResult.canceled) {
    //     parusDbPath.value = dialogResult.filePaths[0]
    //     this.config.parusDbPath = parusDbPath.value
    //     // ipcRenderer.send('set-config', this.config)
    //     window.electronAPI.setConfig(this.config)
    // }
    window.electronAPI.selectDirectory('parusDbPath')
})

const c1DbPath = document.getElementById('c1-db-path')
c1DbPath.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.c1DbPath = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

document.getElementById('select-c1-path').addEventListener('click', async () => {
    // const dialogResult = await mainProcess.selectDirectory(this.config.c1DbPath)
    // const dialogResult = await window.electronAPI.selectDirectory(this.config.c1DbPath)
    // if (!dialogResult.canceled) {
    //     c1DbPath.value = dialogResult.filePaths[0]
    //     this.config.c1DbPath = c1DbPath.value
    //     // ipcRenderer.send('set-config', this.config)
    //     window.electronAPI.setConfig(this.config)
    // }
    window.electronAPI.selectDirectory('c1DbPath')
})

const osvitaDbPath = document.getElementById('osvita-db-path')
osvitaDbPath.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.osvitaDbPath = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

document.getElementById('select-osvita-path').addEventListener('click', async () => {
    // const dialogResult = await mainProcess.selectDirectory(this.config.osvitaDbPath)
    // const dialogResult = await window.electronAPI.selectDirectory(this.config.osvitaDbPath)
    // if (!dialogResult.canceled) {
    //     osvitaDbPath.value = dialogResult.filePaths[0]
    //     this.config.osvitaDbPath = osvitaDbPath.value
    //     // ipcRenderer.send('set-config', this.config)
    //     window.electronAPI.setConfig(this.config)
    // }
    window.electronAPI.selectDirectory('osvitaDbPath')
})

const osvitaBaseDate = document.getElementById('osvita-base-date')
osvitaBaseDate.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.osvitaBaseDate = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const osvitaOrganizationLabel = document.getElementById('osvita-organization-label')
const osvitaOrganization = document.getElementById('osvita-organization')
osvitaOrganization.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.osvitaOrganization = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const osvitaDepartmentLabel = document.getElementById('osvita-department-label')
const osvitaDepartment = document.getElementById('osvita-department')
osvitaDepartment.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.osvitaDepartment = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

const osvitaVersion = document.getElementById('osvita-version')
osvitaVersion.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.osvitaVersion = evt.target.selectedIndex // value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
    setVisible(osvitaOrganization, osvitaVersion.selectedIndex === 0)
    setVisible(osvitaOrganizationLabel, osvitaVersion.selectedIndex === 0)
    setVisible(osvitaDepartment, osvitaVersion.selectedIndex === 0)
    setVisible(osvitaDepartmentLabel, osvitaVersion.selectedIndex === 0)
})

const targetPath = document.getElementById('target-path')
targetPath.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.targetPath = evt.target.value
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

document.getElementById('select-target-path').addEventListener('click', async () => {
    // const dialogResult = await mainProcess.selectDirectory(this.config.targetPath)
    // const dialogResult = await window.electronAPI.selectDirectory(this.config.targetPath)
    // if (!dialogResult.canceled) {
    //     targetPath.value = dialogResult.filePaths[0]
    //     this.config.targetPath = targetPath.value
    //     // ipcRenderer.send('set-config', this.config)
    //     window.electronAPI.setConfig(this.config)
    // }
    window.electronAPI.selectDirectory('targetPath')
})

const isArchive = document.getElementById('isArchive')
isArchive.addEventListener('change', (evt) => {
    evt.preventDefault()
    this.config.isArchive = evt.target.checked
    // ipcRenderer.send('set-config', this.config)
    window.electronAPI.setConfig(this.config)
})

// ipcRenderer.on('config', (event, config) => {
window.electronAPI.onConfig((config) => {
    this.config = config || {}

    serverName.value = config.server || ''
    login.value = config.login || ''
    password.value = config.password || ''
    schema.value = config.schema || ''
    oracleClient.value = config.oracleClient || ''
    bosskServerName.value = config.server || ''
    bosskLogin.value = config.login || ''
    bosskPassword.value = config.password || ''
    bosskDomain.value = config.domain || ''
    bosskPort.value = config.port || ''
    bosskSchema.value = config.schema || ''
    bosskOrgCode.value = config.orgCode || ''
    schemaSys.value = config.schemaSys || ''
    codeSe.value = config.codeSe || ''
    // codeDep.value = config.codeDep || ''
    dbType.value = config.dbType || ''
    targetPath.value = config.targetPath || ''
    afinaDbPath.value = config.afinaDbPath || ''
    parusDbPath.value = config.parusDbPath || ''
    c1DbPath.value = config.c1DbPath || ''
    osvitaDbPath.value = config.osvitaDbPath || ''
    osvitaBaseDate.value = config.osvitaBaseDate || ''
    osvitaVersion.selectedIndex = config.osvitaVersion || ''
    osvitaOrganization.value = config.osvitaOrganization || ''
    osvitaDepartment.value = config.osvitaDepartment || ''

    apkHost.value = config.apkHost || ''
    apkPort.value = config.apkPort || ''
    apkLogin.value = config.apkLogin || ''
    apkPassword.value = config.apkPassword || ''
    apkDatabase.value = config.apkDatabase || ''

    a5dbType.value = config.a5dbType || ''
    a5Host.value = config.a5Host || ''
    a5Port.value = config.a5Port || ''
    a5Login.value = config.a5Login || ''
    a5Password.value = config.a5Password || ''
    a5Database.value = config.a5Database || ''
    a5orgCode.value = config.a5orgCode || ''

    isArchive.checked = config.isArchive

    document.title = `Multi-Export ${config.version || ''}`

    renderMenu()
    renderPanels()
})

renderMenu()
renderPanels()

const countErrors = (targetList) => {
    return targetList.reduce((a, b) => a + (b.err ? 1 : 0), 0)
}

const countCreated = (targetList) => {
    return targetList.reduce(
        (a, b) => a + (b.state === window.electronAPI.result.FILE_CREATED && !b.append ? 1 : 0),
        0
    )
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
        // const fileName = path.basename(arcFileName)
        const fileName = window.electronAPI.basename(arcFileName)
        text += `<br />Запаковано у архівний файл "${fileName}".`
    }

    const timeFinish = new Date()
    const diff = timeFinish.getTime() - timeStart.getTime()
    const hours = pad(Math.round(diff / (1000 * 3600)), 2)
    const minutes = pad(Math.round((diff / (1000 * 60)) % 60), 2)
    const seconds = pad(Math.round((diff / 1000) % 60), 2)
    text += `<br />Час виконання: ${hours}:${minutes}:${seconds}.`

    return text
}

// ipcRenderer.on('done', (event, arcFileName) => {
window.electronAPI.onDone((arcFileName) => {
    buttonRunExport.classList.remove('loading')

    resultToast.classList.remove('toast-error')
    resultToast.classList.remove('toast-warning')
    resultToast.classList.remove('toast-success')
    resultToast.classList.add('toast-success')
    resultToast.innerHTML = stateText(
        countCreated(targetList),
        countErrors(targetList),
        arcFileName
    )
    setVisible(resultPanel, true)
})

// ipcRenderer.on('failed', (event, err) => {
window.electronAPI.onFailed((err) => {
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
        case window.electronAPI.result.FILE_CREATED: {
            // const source = target.sourceFullFileName ? path.basename(target.sourceFullFileName) : ''
            const source = target.sourceFullFileName ? window.electronAPI.basename(target.sourceFullFileName) : ''
            if (source) {
                return target.append ? `Доповнено із ${source}` : `Створено із ${source}`
            }
            return target.append ? 'Файл доповнено' : 'Файл створено'
        }
        case window.electronAPI.result.FILE_EMPTY: {
            // const source = target.sourceFullFileName ? path.basename(target.sourceFullFileName) : ''
            const source = target.sourceFullFileName ? window.electronAPI.basename(target.sourceFullFileName) : ''
            if (target.append && source) {
                return target.append ? `Доповнено із ${source}` : `Створено із ${source}`
            }
            return 'Відсутні дані для експорту'
        }
        case window.electronAPI.result.FILE_ERROR:
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
        // const fileName = path.basename(targetList[i].fullFileName)
        const fileName = window.electronAPI.basename(targetList[i].fullFileName)
        html += `<tr><td>${fileName}</td><td>${stateText}</td></tr>`
    }
    resultTable.innerHTML = html
}

// ipcRenderer.on('push-file', (event, _targetList) => {
window.electronAPI.onPushFile((_targetList) => {
    targetList = _targetList.slice(0)
    renderGrid()
})
