'use strict'

const fs = require('fs')
const path = require('path')
const archiver = require('archiver')
const Target = require('../Target')

const makeArchive = (fullFileName, targetList) => {
    return new Promise((resolve, reject) => {

        // create a file to stream archive data to.
        var output = fs.createWriteStream(fullFileName)
        var archive = archiver('zip', {
            zlib: { level: 9 } // Sets the compression level.
        })

        // listen for all archive data to be written
        // 'close' event is fired only when a file descriptor is involved
        output.on('close', () => {
            resolve(fullFileName)
        })

        // // This event is fired when the data source is drained no matter what was the data source.
        // // It is not part of this library but rather from the NodeJS Stream API.
        // // @see: https://nodejs.org/api/stream.html#stream_event_end
        // output.on('end', () => { 
        //     console.log('Data has been drained') 
        // })

        // good practice to catch warnings (ie stat failures and other non-blocking errors)
        archive.on('warning', (err) => {
            if (err.code === 'ENOENT') {
                // log warning
                console.log(err)
            } else {
                // throw error
                reject(err)
            }
        })

        // good practice to catch this error explicitly
        archive.on('error', (err) => {
            reject(err)
        })

        // pipe archive data to the file
        archive.pipe(output)

        // console.log('makeArchive', targetList.length)
        for (let i = 0; i < targetList.length; i++) {
            // append a file
            if (targetList[i].state == Target.FILE_CREATED) {
                let fileName = path.basename(targetList[i].fileName)
                archive.append(fs.createReadStream(targetList[i].fileName), { name: fileName })
            }
        }

        // finalize the archive (ie we are done appending files but streams have to finish yet)
        // 'close', 'end' or 'finish' may be fired right after calling this method so register to them beforehand
        archive.finalize()
    })
}

module.exports = makeArchive