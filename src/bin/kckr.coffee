path = require 'path'
fs   = require 'fs'
lib  = path.join path.dirname(fs.realpathSync __filename), '../lib'
cli = require lib + '/kckr/cli'

cli.run()
