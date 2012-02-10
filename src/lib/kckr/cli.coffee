fs            = require 'fs'
path          = require 'path'
helpers       = require './helpers'
optparse      = require './optparse'
kckr          = require './kckr'
{spawn, exec} = require 'child_process'

print_line = (line) -> process.stdout.write line + '\n'
print_warn = (line) -> process.stderr.write line + '\n'

# The help banner that is printed when `kckr` is called without arguments.
BANNER = '''
  Usage: kckr [options] path/to/watch

         '''

# The list of all the valid option flags that `kckr` knows how to handle.
SWITCHES = [
  ['-e', '--execute [CMD]',     'cmd to execute upon file change. use {}, {source}, {basename}, {basename_noext}, {dirname} for path placeholder(s).']
  ['-k', '--kickonce',         'just traverse the dir, exec on each match, and quit. don\'t do any watching.']
  ['-r', '--pattern [PATTERN]', 'pattern for filenames to match if watching a dir.']
  ['-h', '--help',              'display this help message']
  ['-v', '--version',           'display the version number']
]

opts         = {}
sources      = []
optionParser = null


run = ->
  parseOptions()
  return usage()                         if opts.help
  return version()                       if opts.version
  return unless opts.execute
  literals = if opts.run then sources.splice 1 else []

  kckrCallback = (source, base) ->
    basename = path.basename source
    basename_noext = basename.replace path.extname(basename), ''
    dirname = path.dirname source
    nobase = source.replace(base, '').replace(/^\/+/, '')
    nobase_noext = nobase.replace path.extname(basename), ''

    cmd = opts.execute.replace "{source}", source
    cmd = cmd.replace "{basename}", basename
    cmd = cmd.replace "{basename_noext}", basename_noext
    cmd = cmd.replace "{dirname}", dirname
    cmd = cmd.replace "{nobase}", nobase
    cmd = cmd.replace "{nobase_noext}", nobase_noext
    cmd = cmd.replace "{}", source

    exec cmd, (err, stdo, stde) ->
        timeLog "<- `#{ cmd }`"
        timeLog "!!! Error" if err
        for line in (l for l in stdo.split "\n" when l isnt '')
          timeLog "-> #{ line }"
        for line in (l for l in stde.split "\n" when l isnt '')
          timeLog "-> #{ line }"

  re = if opts.pattern then new RegExp(opts.pattern) else /.*/
  # The magic... Creates an instance of Kckr, and then sets a callback.
  # Runs the command you specified on the command line.
  k = new kckr.Kckr
    pattern: re
    sources: sources
    callback: kckrCallback
    kickonce: opts.kickonce
  action = if opts.kickonce then "kicking ( O_O)" else "watching (O_O )"
  timeLog "kckr is #{action}"

parseOptions = ->
  optionParser  = new optparse.OptionParser SWITCHES, BANNER
  o = opts      = optionParser.parse process.argv[2..]
  sources       = o.arguments
  return

# Print the `--help` usage message and exit. Deprecated switches are not
# shown.
usage = ->
  print_line (new optparse.OptionParser SWITCHES, BANNER).help()

# Print the `--version` message and exit.
version = ->
  print_line "Kckr version #{kckr.VERSION}"

# When watching scripts, it's useful to log changes with the timestamp.
timeLog = (message) ->
  print_line "#{(new Date).toLocaleTimeString()} - #{message}"

exports.run = run
