'use strict'

const fs = require('fs')

// async function removeFile (fileName) {
//     fs.access(fileName, fs.F_OK, (err) => {
//         if (err) { return }
//         fs.unlink(fileName, (err) => {
//             if (err) {
//                 console.log(err)
//             }
//         })
//     })
// }

function removeFileSync(fileName) {
    if (fs.existsSync(fileName)) {
        fs.unlinkSync(fileName)
    }
}

module.exports = removeFileSync
