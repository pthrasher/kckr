COFFEE=`which coffee`
UGLIFYJS=`which uglifyjs`
LIB=src/lib/kckr
BIN=src/bin

build:
	node bin/kckr.js -e "coffee -cpb {} > {nobase_noext}.js" -r "lib\/.*\.coffee" -k src
	echo "#!/usr/bin/env node" > bin/kckr.js
	coffee -cpb src/bin/kckr.coffee >> bin/kckr.js

watch:
	node bin/kckr.js -e "coffee -cpb {}  > {nobase_noext}.js" -r ".*\.coffee" src

major:
	make build
	npm version `src/build/inc_version major kckr`
	# git push origin && git push origin --tags
	# make publish

minor:
	make build
	npm version `src/build/inc_version minor kckr`
	# git push origin && git push origin --tags
	# make publish

patch:
	make build
	npm version `src/build/inc_version patch kckr`
	# git push origin && git push origin --tags
	# make publish

publish:
	npm publish
