'use strict'

const fs = require('fs')

const makeDir = (dirPath) => {
    return new Promise((resolve, reject) => {
        fs.access(dirPath, fs.F_OK, (err) => {
            if (!err) {
                resolve(dirPath)
            } else {
                fs.mkdir(dirPath, { recursive: true }, (err) => {
                    if (err) {
                        reject(err)
                    } else {
                        resolve(dirPath)
                    }
                })
            }
        })
    })
}

module.exports = makeDir
