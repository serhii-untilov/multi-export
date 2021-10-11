'use strict'

const fs = require('fs')
const path = require('path')
const getFullFileName = require('../helper/getFullFileName')

function getFileList (sourcePath, fileMask) {
    return new Promise((resolve, reject) => {
        fs.readdir(sourcePath, { withFileTypes: true }, (err, dirents) => {
            if (err) reject(err)
            const fileList = dirents
                .filter((el) => { return !el.isDirectory() && fileMask.test(el.name) })
                .map((el) => { return getFullFileName(sourcePath, el.name) })
            resolve(fileList)
        })
    })
}

function getAllFiles (dirPath, fileMask, arrayOfFiles = []) {
    const files = fs.readdirSync(dirPath)
    files.forEach((file) => {
        const fullFileName = getFullFileName(dirPath, file)
        if (fs.statSync(fullFileName).isDirectory()) {
            arrayOfFiles = getAllFiles(fullFileName, fileMask, arrayOfFiles)
        } else {
            if (fileMask.test(file)) {
                arrayOfFiles.push(fullFileName)
            }
        }
    })
    return arrayOfFiles
}

module.exports = {
    getFileList,
    getAllFiles
}
