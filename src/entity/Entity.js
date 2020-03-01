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
        let header = ''
        let separator = ''
        for (const prop in this) {
            header += `${separator}${this[prop]}`
            separator = ';'
        }
        header += '\n'
        return header
    }
}

module.exports = Entity