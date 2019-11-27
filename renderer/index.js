'use strict'

const { ipcRenderer } = require('electron')
const Config = require('../Config')

const config = null

const homePanel = document.getElementById('home-panel')
const isproPanel = document.getElementById('ispro-panel')
const afinaPanel = document.getElementById('afina-panel')
const parusPanel = document.getElementById('parus-panel')
const c1Panel = document.getElementById('c1-panel')
const controlPanel = document.getElementById('control-panel')
const resultPanel = document.getElementById('result-panel')
const resultTable = document.getElementById('resultTable')
const bodyPanel = document.getElementById('body-panel')
const footerPanel = document.getElementById('footer-panel')

const setVisible = (element, visible) => {
  let className = "d-hide"
  if (visible)
    element.classList.remove(className)
  else {
    element.classList.remove(className)
    element.classList.add(className)
  }
}

const setSelected = (element, selected) => {
  let className = "text-dark"
  if (selected) {
    element.classList.remove(className)
  }
  else {
    element.classList.remove(className)
    element.classList.add(className)
  }
}

const renderPanels = () => {
  setVisible(homePanel, !this.config || this.config.panel === Config.HOME)
  setVisible(isproPanel, this.config && this.config.panel === Config.ISPRO)
  setVisible(afinaPanel, this.config && this.config.panel === Config.AFINA)
  setVisible(parusPanel, this.config && this.config.panel === Config.PARUS)
  setVisible(c1Panel, this.config && this.config.panel === Config.C1)
  setVisible(controlPanel, this.config && this.config.panel != Config.HOME)
  setVisible(bodyPanel, false)
  setVisible(footerPanel, this.config && this.config.panel !== Config.HOME)
  setVisible(resultPanel, false)
  console.log('renderPanels', this.config, afinaPanel, parusPanel, c1Panel, bodyPanel, resultPanel)
}

const renderMenu = () => {
  if (!this.config)
    return
  setSelected(buttonSelectISPro, this.config.panel == Config.ISPRO)
  setSelected(buttonSelectAfina, this.config.panel == Config.AFINA)
  setSelected(buttonSelectParus, this.config.panel == Config.PARUS)
  setSelected(buttonSelect1C, this.config.panel == Config.C1)
  console.log('renderMenu', this.config, buttonSelectISPro, buttonSelectAfina, buttonSelectParus, buttonSelect1C)
}

const buttonSelectHome = document.getElementById('selectHome')
!buttonSelectHome || buttonSelectHome.addEventListener('click', () => {
  this.config.panel = Config.HOME
  ipcRenderer.send('set-config', this.config)
  renderPanels()
})

const buttonSelectISPro = document.getElementById('selectISPro')
buttonSelectISPro.addEventListener('click', () => {
  if (this.config.panel == Config.ISPRO)
    return
  this.config.panel = Config.ISPRO
  ipcRenderer.send('set-config', this.config)
  renderMenu()
  renderPanels()
})

const buttonSelectAfina = document.getElementById('selectAfina')
buttonSelectAfina.addEventListener('click', () => {
  if (this.config.panel == Config.AFINA)
    return
  this.config.panel = Config.AFINA
  ipcRenderer.send('set-config', this.config)
  renderMenu()
  renderPanels()
})

const buttonSelectParus = document.getElementById('selectParus')
buttonSelectParus.addEventListener('click', () => {
  if (this.config.panel == Config.PARUS)
    return
  this.config.panel = Config.PARUS
  ipcRenderer.send('set-config', this.config)
  renderMenu()
  renderPanels()
})

const buttonSelect1C = document.getElementById('select1C')
buttonSelect1C.addEventListener('click', () => {
  if (this.config.panel == Config.C1)
    return
  this.config.panel = Config.C1
  ipcRenderer.send('set-config', this.config)
  renderMenu()
  renderPanels()
})

const buttonRunExport = document.getElementById('runExport')
buttonRunExport.addEventListener('click', () => {
  setVisible(bodyPanel, true)
  ipcRenderer.send('run-export')
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

ipcRenderer.on('done', (event, fileList) => {
  setVisible(resultPanel, true)
})

ipcRenderer.on('failed', (event, err) => {
  setVisible(resultPanel, true)
})

ipcRenderer.on('push-file', (event, fileList) => {
  var html = ''
  for (var i = 0; i < fileList.length; i++) {
    html += `<tr><td>${fileList[i].fileName}</td><td>${fileList[i].state}</td></tr>`
  }
  resultTable.innerHTML = html
})

