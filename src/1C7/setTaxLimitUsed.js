'use strict'

const fs = require('fs')
const YADBF = require('yadbf')
const getFullFileName = require('../helper/getFullFileName')

function setTaxLimitUsed(config, dictionary) {
    return new Promise(async (resolve, reject) => {
        let fullFileName = getFullFileName(config.c1DbPath, 'PLG.DBF')
        fs.exists(fullFileName, (exists) => {
            if (exists) {
                fs.createReadStream(fullFileName)
                    .pipe(new YADBF({ encoding: 'cp1251' }))
                    .on('data', record => {
                        if (!record.deleted) {
                            dictionary.setTaxLimitUsed(record.CD)
                        }
                    })
                    .on('end', () => {
                        resolve(true)
                    })
                    .on('error', err => {
                        console.error(`an error was thrown: ${err}`);
                        reject(err)
                    })
            } else {
                resolve(true)
            }
        })
    })
}

module.exports = setTaxLimitUsed
