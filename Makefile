COFFEE=`which coffee`
UGLIFYJS=`which uglifyjs`
LIB=src/lib/kckr
BIN=src/bin

build:
	node bin/kckr.js -e "coffee -cp {} | uglifyjs -nc -nm > {nobase_noext}.js" -r ".*\.coffee" -k src

watch:
	node bin/kckr.js -e "coffee -cp {} | uglifyjs -nc -nm > {nobase_noext}.js" -r ".*\.coffee" src
