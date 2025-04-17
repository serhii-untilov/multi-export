function removeHeader(queryText) {
    const re = /\/\*BEGIN-OF-HEAD\*\/[.\s\W\n\r\w]*\/\*END-OF-HEAD\*\//gim
    queryText = queryText.replace(re, '')
    return queryText
}

function replace_SYS_SCHEMA(queryText, schemaSys) {
    // find /*SYS_SCHEMA*/.sspr
    // replace to ${schemaSys}.sspr
    const re = /\/\*SYS_SCHEMA\*\/\w+\./gim
    while (re.test(queryText)) {
        queryText = queryText.replace(re, schemaSys + '.')
    }
    return queryText
}

function replace_FIRM_SCHEMA(queryText, schemaFirm) {
    // find /*FIRM_SCHEMA*/.sspr
    // replace to ${schemaFirm}.sspr
    const re = /\/\*FIRM_SCHEMA\*\/\w+\./gim
    while (re.test(queryText)) {
        queryText = queryText.replace(re, schemaFirm + '.')
    }
    return queryText
}

function replace_SYSSTE_CD(queryText, sysste_cd) {
    // find /*SYSSTE_CD*/.sspr
    // replace to sysste_cd
    const re = /\/\*SYSSTE_CD\*\//gim
    while (re.test(queryText)) {
        queryText = queryText.replace(re, "'" + sysste_cd + "'")
    }
    return queryText
}

function replace_SPRPDR_CD(queryText, sprpdr_cd) {
    // find /*SPRPDR_CD*/.sspr
    // replace to sprpdr_cd
    const re = /\/\*SPRPDR_CD\*\//gim
    while (re.test(queryText)) {
        queryText = queryText.replace(re, "'" + sprpdr_cd + "'")
    }
    return queryText
}

const SYSSTE_BEGIN = '/*SYSSTE_BEGIN*/'
const SYSSTE_END = '/*SYSSTE_END*/'
function remove_SYSSTE(queryText) {
    // const re = /\/\*SYSSTE_BEGIN\*\/[.\s\W\n\r\w]*\/\*SYSSTE_END\*\//gim
    // queryText = queryText.replace(re, '')
    let begin, end
    do {
        begin = queryText.indexOf(SYSSTE_BEGIN)
        end = queryText.indexOf(SYSSTE_END)
        if (begin < end) {
            end += SYSSTE_END.length
            if (!begin && end === queryText.length) {
                return ''
            }
            if (!begin) {
                queryText = queryText.substring(end)
            } else if (end === queryText.length) {
                queryText = queryText.substring(0, begin)
            } else {
                queryText = queryText.substring(0, begin) + queryText.substring(end)
            }
        }
    } while (begin < end)
    return queryText
}

module.exports = {
    removeHeader,
    replace_SYS_SCHEMA,
    replace_FIRM_SCHEMA,
    replace_SYSSTE_CD,
    replace_SPRPDR_CD,
    remove_SYSSTE
}