git fetch
git pull
fnm install v20.19.2
fnm use v20.19.2
fnm default v20.19.2
Remove-Item -Recurse -Force .\node_modules\
# Remove-Item -Force .\package-lock.json
npm cache clean --force
npm i -g node-gyp
npm i -g windows-build-tools
# npm update
# npm i
npm ci