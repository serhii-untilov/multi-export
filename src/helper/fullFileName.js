'use strict'

const path = require('path')

const fullFileName = (pathString, fileName) => {
    if (pathString[pathString.length - 1] != path.sep)
        pathString += path.sep 
    return `${pathString}${fileName}`
}

module.exports = fullFileName