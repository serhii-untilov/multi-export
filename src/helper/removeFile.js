'use strict'

const fs = require('fs')

async function removeFile (fileName) {
    fs.exists(fileName, (exists) => {
        if (exists) {
            fs.unlink(fileName, (err) => {
                console.log(err)
            })
        }
    })
}

module.exports = removeFile
