const { dialog } = require('electron')

async function selectDirectory(defaultPath) {
    const options = {
        title: 'Виберіть каталог',
        defaultPath: defaultPath,
        buttonLabel: 'Вибрати',
        properties: ['openDirectory', 'promptToCreate']
    }
    return await dialog.showOpenDialog(options)
}

module.exports = { selectDirectory }