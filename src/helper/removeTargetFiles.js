'use strict'

const removeFile = require('./removeFile')
const Target = require('../Target')

function removeTargetFiles(targetList) {
    for (let i = 0; i < targetList.length; i++) {
        if (targetList[i].state === Target.FILE_CREATED) {
            removeFile(targetList[i].fullFileName)
        }
    }
}

module.exports = removeTargetFiles
