'use strict'

const { ipcRenderer } = require('electron')

const config = null

const buttonRunExport = document.getElementById('runExport')
buttonRunExport.addEventListener('click', () => {
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
})

ipcRenderer.on('done', (event, fileList) => {
  const fileListElement = document.getElementById('fileList')
  var html = htmlFileList(fileList)
  html += '<li class="file-item">Done!</li>'
  fileListElement.innerHTML = html
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

