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

major:
	version=`src/build/inc_version major kckr`
	npm version ${version}
	git commit -avm "Major commit -> ${version}"
	git tag ${version}
	git push origin && git push origin --tags
	make publish

minor:
	version=`src/build/inc_version minor kckr`
	npm version ${version}
	git commit -avm "Minor commit -> ${version}"
	git tag ${version}
	git push origin && git push origin --tags
	make publish

patch:
	npm version `src/build/inc_version patch kckr`
	git commit -avm "Patch commit -> `src/build/inc_version patch kckr`"
	git tag `src/build/inc_version patch kckr`
	# git push origin && git push origin --tags
	# make publish

publish:
	npm publish

