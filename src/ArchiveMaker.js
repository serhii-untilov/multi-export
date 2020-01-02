'use strict'

const fs = require('fs')
const path = require('path')
const archiver = require('archiver')
const Target = require('./Target')

const FILE_EXT = '.zip'

class ArchiveMaker {
    constructor(config, archiveName) {
        this.config = config
        this.archiveName = archiveName || 'archive'
    }
    
    getArchiveFileName() {
        let fileName = this.archiveName
        let targetPath = this.config.targetPath[this.config.targetPath.length - 1] == path.sep 
            ? this.config.targetPath 
            : `${this.config.targetPath}${path.sep}`
        return `${targetPath}${fileName}${FILE_EXT}`
    }

    make(targetList, done) {
        // create a file to stream archive data to.
        let arcFileName = this.getArchiveFileName()
        var output = fs.createWriteStream(arcFileName)
        var archive = archiver('zip', {
            zlib: { level: 9 } // Sets the compression level.
        })

        // listen for all archive data to be written
        // 'close' event is fired only when a file descriptor is involved
        output.on('close', function () {
            console.log(archive.pointer() + ' total bytes')
            console.log('archiver has been finalized and the output file descriptor has closed.')
            done(arcFileName)
        })

        // This event is fired when the data source is drained no matter what was the data source.
        // It is not part of this library but rather from the NodeJS Stream API.
        // @see: https://nodejs.org/api/stream.html#stream_event_end
        output.on('end', function () {
            console.log('Data has been drained')
        })

        // good practice to catch warnings (ie stat failures and other non-blocking errors)
        archive.on('warning', function (err) {
            if (err.code === 'ENOENT') {
                // log warning
            } else {
                // throw error
                throw err
            }
        })

        // good practice to catch this error explicitly
        archive.on('error', function (err) {
            throw err
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
    }
}

module.exports = ArchiveMaker