#!/usr/bin/env node
path = require 'path'
fs   = require 'fs'
lib  = path.join(path.join(path.dirname(fs.realpathSync __filename), '../lib'), 'kckr/cli')
cli = require lib

cli.run()
