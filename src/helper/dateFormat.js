'use strict'

const MIN_DATE = new Date('1900-01-01')

function dateFormat (date) {
    if (date instanceof Date && date > MIN_DATE) {
        return date.getFullYear() + '-' + ('0' + (date.getMonth() + 1)).slice(-2) + '-' + ('0' + date.getDate()).slice(-2)
    }
    return ''
}

module.exports = dateFormat
