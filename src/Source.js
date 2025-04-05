'use strict'

class Source {
    read(config, sendFile, sendDone) {
        throw new Error('Abstract method. Your need implement it on an inherited class.')
    }
}

module.exports = Source
