'use strict'

const fs = require('fs')

const makeDir = (dirPath) => {
    return new Promise((resolve, reject) => {
        fs.exists(dirPath, (exists) => {
            if (exists) {
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
