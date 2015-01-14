# env ENV='Browser' browserify -c 'coffee -sc' moduleExportTest.coffee -o ./out.js
# browserify -c 'coffee -sc' BNTest.coffee -o ./BNOut.js
# browserify --ignore 'browser' -c 'coffee -sc' BNTest.coffee -o ./IgnoreBrowserOut.js
# browserify --exclude 'browser' -c 'coffee -sc' BNTest.coffee -o ./excludingBrowserOut.js
env ENV='Browser' browserify --ignore 'socket.io' -c 'coffee -sc' BNTest.coffee -o ./excludeModuleOut.js

