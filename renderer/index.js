'use strict'

const { ipcRenderer } = require('electron')
const { shell } = require('electron')
const Config = require('../src/Config')
const Target = require('../src/Target')

const config = null

const targetList = []

const homePanel = document.getElementById('home-panel')
const isproPanel = document.getElementById('ispro-panel')
const afinaPanel = document.getElementById('afina-panel')
const parusPanel = document.getElementById('parus-panel')
const c1Panel = document.getElementById('c1-panel')
const commonParamsPanel = document.getElementById('common-params-panel')
const controlPanel = document.getElementById('control-panel')
const resultPanel = document.getElementById('result-panel')
const resultToast = document.getElementById('result-toast')
const resultTable = document.getElementById('result-table')
const bodyPanel = document.getElementById('body-panel')
const footerPanel = document.getElementById('footer-panel')

const setVisible = (element, visible) => {
  let hide = "d-hide"
  if (visible)
    element.classList.remove(hide)
  else {
    element.classList.remove(hide)
    element.classList.add(hide)
  }
}

const setSelected = (element, selected) => {
  let bold = "bold"
  if (selected) {
    element.classList.remove(bold)
    element.classList.add(bold)
  }
  else {
    element.classList.remove(bold)
  }
}

const renderPanels = () => {
  setVisible(homePanel, !this.config || this.config.source === Config.HOME)
  setVisible(isproPanel, this.config && this.config.source === Config.ISPRO)
  setVisible(afinaPanel, this.config && this.config.source === Config.AFINA)
  setVisible(parusPanel, this.config && this.config.source === Config.PARUS)
  setVisible(c1Panel, this.config && this.config.source === Config.C1)
  setVisible(commonParamsPanel, this.config && this.config.source != Config.HOME)
  setVisible(controlPanel, this.config && this.config.source != Config.HOME)
  setVisible(bodyPanel, false)
  setVisible(footerPanel, this.config && this.config.source === Config.HOME)
  setVisible(resultPanel, false)
}

const renderMenu = () => {
  if (!this.config)
    return
  setSelected(buttonSelectISPro, this.config.source == Config.ISPRO)
  setSelected(buttonSelectAfina, this.config.source == Config.AFINA)
  setSelected(buttonSelectParus, this.config.source == Config.PARUS)
  setSelected(buttonSelect1C, this.config.source == Config.C1)
}

const selectHome = () => {
  if (this.config.source == Config.HOME)
    return
  targetList.length = 0
  this.config.source = Config.HOME
  ipcRenderer.send('set-config', this.config)
  renderMenu()
  renderPanels()
}
document.getElementById('selectHome').addEventListener('click', selectHome)

const selectIspro = () => {
  if (this.config.source == Config.ISPRO)
    return
  targetList.length = 0
  this.config.source = Config.ISPRO
  ipcRenderer.send('set-config', this.config)
  renderMenu()
  renderPanels()
}
const buttonSelectISPro = document.getElementById('selectISPro')
buttonSelectISPro.addEventListener('click', selectIspro)
document.getElementById('homeSelectISPro').addEventListener('click', selectIspro)

const selectAfina = () => {
  if (this.config.source == Config.AFINA)
    return
  targetList.length = 0    
  this.config.source = Config.AFINA
  ipcRenderer.send('set-config', this.config)
  renderMenu()
  renderPanels()
}
const buttonSelectAfina = document.getElementById('selectAfina')
buttonSelectAfina.addEventListener('click', selectAfina)
document.getElementById('homeSelectAfina').addEventListener('click', selectAfina)

const selectParus = () => {
  if (this.config.source == Config.PARUS)
    return
  targetList.length = 0    
  this.config.source = Config.PARUS
  ipcRenderer.send('set-config', this.config)
  renderMenu()
  renderPanels()
}
const buttonSelectParus = document.getElementById('selectParus')
buttonSelectParus.addEventListener('click', selectParus)
document.getElementById('homeSelectParus').addEventListener('click', selectParus)

const select1C = () => {
  if (this.config.source == Config.C1)
    return
  targetList.length = 0    
  this.config.source = Config.C1
  ipcRenderer.send('set-config', this.config)
  renderMenu()
  renderPanels()
}
const buttonSelect1C = document.getElementById('select1C')
buttonSelect1C.addEventListener('click', select1C)
document.getElementById('homeSelect1C').addEventListener('click', select1C)

document.getElementById('homeSelectA5').addEventListener('click', () => {
  shell.openExternal('https://a5buh.com')
})

document.getElementById('selectA5').addEventListener('click', () => {
  shell.openExternal('https://a5buh.com')
})

document.getElementById('selectGitHub').addEventListener('click', () => {
  shell.openExternal('https://github.com/sergey-untilov/multi-export')
})

document.getElementById('run-export').addEventListener('click', () => {
  setVisible(bodyPanel, true)
  targetList.length = 0
  ipcRenderer.send('run-export', this.config)
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

const afinaDbPath = document.getElementById('afina-db-path')
afinaDbPath.addEventListener('change', (evt) => {
  evt.preventDefault()
  this.config.afinaDbPath = evt.target.value
  ipcRenderer.send('set-config', this.config)
})

const parusDbPath = document.getElementById('parus-db-path')
parusDbPath.addEventListener('change', (evt) => {
  evt.preventDefault()
  this.config.parusDbPath = evt.target.value
  ipcRenderer.send('set-config', this.config)
})

const c1DbPath = document.getElementById('c1-db-path')
c1DbPath.addEventListener('change', (evt) => {
  evt.preventDefault()
  this.config.c1DbPath = evt.target.value
  ipcRenderer.send('set-config', this.config)
})

const targetPath = document.getElementById('target-path')
targetPath.addEventListener('change', (evt) => {
  evt.preventDefault()
  this.config.targetPath = evt.target.value
  ipcRenderer.send('set-config', this.config)
})

const isArchive = document.getElementById('isArchive')
isArchive.addEventListener('change', (evt) => {
  evt.preventDefault()
  this.config.isArchive = evt.target.checked
  ipcRenderer.send('set-config', this.config)
})

ipcRenderer.on('config', (event, config) => {
  this.config = config

  serverName.value = config.server
  login.value = config.login
  password.value = config.password
  schema.value = config.schema
  schemaSys.value = config.schemaSys
  codeSe.value = config.codeSe
  targetPath.value = config.targetPath
  afinaDbPath.value = config.afinaDbPath
  parusDbPath.value = config.parusDbPath
  c1DbPath.value = config.c1DbPath

  isArchive.checked = config.isArchive

  renderMenu()
  renderPanels()
})

renderMenu()
renderPanels()

const countErrors = (targetList) => {
  let count = 0
  for (var i = 0; i < targetList.length; i++) {
    if (targetList[i].err)
      count++
  }
  return count
}

const statusText = (errors) => {
  if (errors) {
    return `Експорт виконано з помилками (${errors}).`
  } else {
    return 'Експорт виконано успішно.'
  }
}

ipcRenderer.on('done', (event) => {
  resultToast.classList.remove('toast-error')
  resultToast.classList.remove('toast-success')
  resultToast.classList.add('toast-success')
  resultToast.innerHTML = statusText(countErrors(targetList))
  setVisible(resultPanel, true)
})


ipcRenderer.on('failed', (event, err) => {
  resultToast.classList.remove('toast-success')
  resultToast.classList.remove('toast-error')
  resultToast.classList.add('toast-error')
  resultToast.innerHTML = 'Експорт не виконано. ' + err
  resultTable.innerHTML = ''
  setVisible(bodyPanel, false)
  setVisible(resultPanel, true)
})

const getStateText = (target) => {
  switch (target.state) {
    case Target.FILE_CREATED:
      return `Файл створено.`
    case Target.FILE_EMPTY:
      return 'Файл не створено. Відсутні дані для експорту.'
    case Target.FILE_ERROR:
      console.log(target)
      return `Помилка. ${target.err.message}` 
    default:
      return 'Невідома помилка.'
  }
}

ipcRenderer.on('push-file', (event, target) => {
  targetList.push(target)
  var html = ''
  for (var i = 0; i < targetList.length; i++) {
    let stateText = getStateText(targetList[i])
    html += `<tr><td>${targetList[i].fileName}</td><td>${stateText}</td></tr>`
  }
  resultTable.innerHTML = html
})

