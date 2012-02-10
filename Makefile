COFFEE=`which coffee`
UGLIFYJS=`which uglifyjs`
LIB=src/lib/kckr
BIN=src/bin

build:
	node bin/kckr.js -e "coffee -cpb {} | uglifyjs -nc -nm > {nobase_noext}.js" -r "lib\/.*\.coffee" -k src
	echo "#!/usr/bin/env node" > bin/kckr.js
	coffee -cpb src/bin/kckr.coffee | uglifyjs -nc -nm >> bin/kckr.js

watch:
	node bin/kckr.js -e "coffee -cpb {} | uglifyjs -nc -nm > {nobase_noext}.js" -r ".*\.coffee" src
