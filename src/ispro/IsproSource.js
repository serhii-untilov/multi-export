'use strict'

const fs = require('fs')
const _fsExtra = require('fs-extra')
const path = require('path')
const Source = require('../Source')
const Target = require('../Target')
const IsproTarget = require('./IsproTarget')

const SQL_FILES_DIR = './assets/ispro'

class IsproSource extends Source {
    constructor() {
        super()
    }

    getFileList() {
        // let fileList = []
        // try {
        //     fs.readdir(SQL_FILES_DIR, function (err, files) {
        //         console.log('debug', files)
        //         fileList = files.map(function (file) {
        //             return SQL_FILES_DIR + path.sep + file
        //         })
        //         console.log('debug', fileList)
        //     })
        // } catch (err) {
        //     console.log(err)
        // }
        // console.log('debug', fileList)
        let fileList = await (0, _fsExtra().readdir)(SQL_FILES_DIR);
        return fileList
    }

    read(config, resolve) {
        let fileList = this.getFileList()
        console.log('debug', fileList)
        for (let i = 0; i < fileList.length; i++) {
            let target = new IsproTarget(files[i])
            try {
                fs.readFile(fileList[i], 'utf8', function (err, queryText) {
                    target.makeFile(config, queryText)
                })
            } catch (err) {
                confole.log(err)
                target.state = Target.FILE_ERROR
                target.err = err
            }
            resolve(target)
        }
    }
}

module.exports = IsproSource
