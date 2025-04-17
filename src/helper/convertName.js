const dictionary = {
    'id': 'ID',
    'CODE': 'code',
    'NAME': 'name',
    'DESCRIPTION': 'description',
    'FULLFIO': 'fullFIO',
    'GENNAME': 'genName',
    'DATNAME': 'datName',
    'ACCUSATIVENAME': 'accusativeName',
    'INSNAME': 'insName',
    'TABNUM': 'tabNum',
    'STATE': 'state',
    'SEXTYPE': 'sexType',
    'BIRTHDATE': 'birthDate',
    'TAXCODE': 'taxCode',
    'PHONEMOBILE': 'phoneMobile',
    'PHONEWORKING': 'phoneWorking',
    'PHONEHOME': 'phoneHome',
    'EMAIL': 'email',
    'LOCNAME': 'locName',
    'DAYBIRTHDATE': 'dayBirthDate',
    'MONTHBIRTHDATE': 'monthBirthDate',
    'YEARBIRTHDATE': 'yearBirthDate'
}

function convertName(name) {
    return dictionary[name] || name
}

module.exports = {
    convertName
}
