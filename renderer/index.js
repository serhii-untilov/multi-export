'use strict'

const { ipcRenderer } = require('electron')
const Config = require('../Config')

const config = null

const homePanel = document.getElementById('home-panel')
const isproPanel = document.getElementById('ispro-panel')
//const controlPanel = document.getElementById('control-panel')
const resultPanel = document.getElementById('result-panel')
const bodyPanel = document.getElementById('body-panel')
const footerPanel = document.getElementById('footer-panel')


const renderPanels = () => {
  if (this.config == null)
    return
  homePanel.style.display = 'none' // this.config.panel === Config.HOME ? 'block' : 'none'
  isproPanel.style.display = this.config.panel === Config.ISPRO ? 'block' : 'none'
  // controlPanel.style.display = this.config.panel === Config.HOME ? 'none' : 'block'
  // bodyPanel.style.display = this.config.panel === Config.HOME ? 'none' : 'block'
  footerPanel.style.display = 'none' // this.config.panel === Config.HOME ? 'none' : 'block'
}

const buttonSelectHome = document.getElementById('selectHome')
buttonSelectHome.addEventListener('click', () => {
  // this.config.panel = Config.HOME
  // ipcRenderer.send('set-config', this.config)
  // renderPanels()
})

const buttonSelectISPro = document.getElementById('selectISPro')
buttonSelectISPro.addEventListener('click', () => {
  if (this.config.panel == Config.ISPRO)
    return
  this.config.panel = Config.ISPRO
  ipcRenderer.send('set-config', this.config)
  renderPanels()
  bodyPanel.style.display = 'none'
  resultPanel.style.display = 'none'
})

const buttonSelectAfina = document.getElementById('selectAfina')
buttonSelectAfina.addEventListener('click', () => {
  if (this.config.panel == Config.AFINA)
    return
  this.config.panel = Config.AFINA
  ipcRenderer.send('set-config', this.config)
  renderPanels()
  bodyPanel.style.display = 'none'
  resultPanel.style.display = 'none'

})

const buttonSelectParus = document.getElementById('selectParus')
buttonSelectParus.addEventListener('click', () => {
  if (this.config.panel == Config.PARUS)
    return
  this.config.panel = Config.PARUS
  ipcRenderer.send('set-config', this.config)
  renderPanels()
  bodyPanel.style.display = 'none'
  resultPanel.style.display = 'none'
})

const buttonSelect1C = document.getElementById('select1C')
buttonSelect1C.addEventListener('click', () => {
  if (this.config.panel == Config.C1)
    return
  this.config.panel = Config.C1
  ipcRenderer.send('set-config', this.config)
  renderPanels()
  bodyPanel.style.display = 'none'
  resultPanel.style.display = 'none'
})

const buttonRunExport = document.getElementById('runExport')
buttonRunExport.addEventListener('click', () => {
  bodyPanel.style.display = 'block'
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

const path = document.getElementById('path')
path.addEventListener('change', (evt) => {
  evt.preventDefault()
  this.config.path = evt.target.value
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
  path.value = config.path
  isArchive.checked = config.isArchive
  renderPanels()
})

renderPanels()
bodyPanel.style.display = 'none'
resultPanel.style.display = 'none'

ipcRenderer.on('done', (event, fileList) => {
  // const fileListElement = document.getElementById('fileList')
  // var html = htmlFileList(fileList)
  // html += '<li class="file-item">Done!</li>'
  // fileListElement.innerHTML = html
  resultPanel.style.display = 'block'
})

const htmlFileList = (fileList) => {
  var html = ''
  for (var i = 0; i < fileList.length; i++) {
    html += `<li class="file-item">${fileList[i]}</li>`
  }
  return html
}

ipcRenderer.on('push-file', (event, fileList) => {
  const fileListElement = document.getElementById('fileList')
  fileListElement.innerHTML = htmlFileList(fileList)
})

