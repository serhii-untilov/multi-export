'use strict'

const fs = require('fs')
const YADBF = require('yadbf')
const getFullFileName = require('../helper/getFullFileName')

function fillPayElActuallyUsed(config, dictionary) {
    let fileList = ['RL.DBF', 'RL_Dogl.DBF', 'RL_Lik_F.DBF', 'RL_Lik_P.DBF']
    return Promise.all(
        fileList.map((fileName) => {
            return new Promise(async (resolve, reject) => {
                let fullFileName = getFullFileName(config.c1DbPath, fileName)
                fs.exists(fullFileName, (exists) => {
                    if (exists) {
                        fs.createReadStream(fullFileName)
                            .pipe(new YADBF({ encoding: 'cp1251' }))
                            .on('data', record => {
                                if (!record.deleted) {
                                    dictionary.setPayElActuallyUsed(record['CD'])
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
        })
    )
}

module.exports = fillPayElActuallyUsed
