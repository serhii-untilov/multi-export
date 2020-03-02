'use strict'

function makePositionID(departmentID, dictPositionID) {
    return departmentID * 10000 + dictPositionID
}

module.exports = makePositionID