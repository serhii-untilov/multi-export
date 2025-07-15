function replaceSpecialSymbols(value) {
    if (value === null) {
        return '';
    }

    if (typeof value !== 'string') {
        return value
    }

    return value
        .replace(/\r/g, '')
        .replace(/\n/g, '')
        .replace(/"/g, '`')
        .replace(/'/g, '`')
        .replace(/\\/g, '')
        .replace(/\//g, '')
        .replace(/\t/g, '')
        .replace(/;/g, ',')
        .replace(/”/g, '`')
        .replace(/\s{2,}/gm, ' ')
        .trim();
}