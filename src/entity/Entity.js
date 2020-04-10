'use strict'

class Entity {
    constructor() {
    }

    getHeader() {
        let header = ''
        let separator = ''
        for (const prop in this) {
            header += `${separator}${prop}`
            separator = ';'
        }
        header += '\n'
        return header
    }

    getRecord() {
        let record = ''
        let separator = ''
        for (const prop in this) {
            record += `${separator}${this[prop]}`
            separator = ';'
        }
        record = record.replace(/(\r\n|\n|\r)/gm, "")
        record += '\n'
        return record
    }
}

module.exports = Entity