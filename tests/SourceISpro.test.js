'use strict'

const fs = require('fs')

const SQL_FILES_DIR = './assets/ispro'

test('Test readdirSync', () => {
    const fileList = fs.readdirSync(SQL_FILES_DIR)
    expect(fileList.length > 0).toBe(true)
})

// test('Test async read dir', () => {

//     let readDir = () => {
//         return new Promise((resolve, reject) => {
//             fs.readdir(SQL_FILES_DIR, (err, files) => {
//                 if (err) {
//                     reject(err)
//                 } else {
//                     resolve(files)
//                 }
//             })
//         })
//     }

//     readDir()
//         .then((fileList) => {
//             expect(fileList.length > 0).toBe(true)
//         })
// })

// test('Test async read files in dir', () => {

//     let readDir = () => {
//         return new Promise((resolve, reject) => {
//             fs.readdir(SQL_FILES_DIR, (err, files) => {
//                 if (err) reject(err)
//                 resolve(files)
//             })
//         })
//     }

//     let readFile = (fileName) => {
//         return new Promise((resolve, reject) => {
//             fs.readFile(fileName, 'utf8', function (err, text) {
//                 if (err) reject(err)
//                 resolve({ fileName, text })
//             })
//         })

//     }

//     let readFileList = (files) => {
//         let promises = []
//         for (let i = 0; i < files.length; i++) {
//             promises.push(readFile(files[i]))
//         }
//         return new Promise.all(promises)
//     }

//     readDir()
//         .then(files => readFileList(files))
//         .catch(err => {console.log(err)})
// })
