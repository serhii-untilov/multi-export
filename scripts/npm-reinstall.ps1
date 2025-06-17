Remove-Item -Recurse -Force .\node_modules\
Remove-Item -Force .\package-lock.json
npm cache clean --force
npm i -g node-gyp
npm i -g windows-build-tools
npm update
npm i