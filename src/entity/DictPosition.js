'use strict'

class DictPosition {
    constructor() {
        this.ID = 0
        this.code = ''
        this.name = ''
    }

    getHeader() {
        return 'ID;code;name\n'
    }

    getRecord() {
        return `${this.ID};${this.code};${this.name}\n`
    }
}

module.exports = DictPosition