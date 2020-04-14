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
            let field = this[prop]
            let index = field instanceof String ? field.indexOf("\r") : -1
            if (index >= 0)
                field[index] = 0
            record += `${separator}${field}`
            separator = ';'
        }
        record += '\n'
        return record
    }
}

module.exports = Entity