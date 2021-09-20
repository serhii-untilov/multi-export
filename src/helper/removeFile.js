'use strict'

const fs = require('fs')

async function removeFile (fileName) {
    fs.access(fileName, fs.F_OK, (err) => {
        if (err) { return }
        fs.unlink(fileName, (err) => {
            console.log(err)
        })
    })
}

module.exports = removeFile
