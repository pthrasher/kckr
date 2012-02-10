COFFEE=`which coffee`
UGLIFYJS=`which uglifyjs`
LIB=src/lib/kckr
BIN=src/bin

build:
	${COFFEE} -cp ${LIB}/kckr.coffee | ${UGLIFYJS} -nc -nm > lib/kckr/kckr.js
	${COFFEE} -cp ${LIB}/optparse.coffee | ${UGLIFYJS} -nc -nm > lib/kckr/optparse.js
	${COFFEE} -cp ${LIB}/cli.coffee | ${UGLIFYJS} -nc -nm > lib/kckr/cli.js
	${COFFEE} -cp ${LIB}/helpers.coffee | ${UGLIFYJS} -nc -nm > lib/kckr/helpers.js
	${COFFEE} -cp ${BIN}/kckr.coffee | ${UGLIFYJS} -nc -nm > bin/kckr.js

watch:
	node bin/kckr.js -e "coffee -cp {} | uglifyjs -nc -nm > {nobase_noext}.js" -r ".*\.coffee" src
