'use strict'

const fs = require('fs')
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

module.exports = getFileList
