'use strict'

const fs = require('fs')

function removeFile(fileName) {
    fs.exists(fileName, (exists) => {
        if (exists) {
            fs.unlink(fileName, (err) => { 
            })
        }
    })
}

module.exports = removeFile