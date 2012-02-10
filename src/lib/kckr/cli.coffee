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
  ['-e', '--execute [CMD]',     'cmd to execute upon file change. use {} for path placeholder.']
  ['-p', '--path',              'path to dir, or file to watch.']
  ['-r', '--pattern [PATTERN]', 'pattern for filenames to match if watching a dir.']
  ['-h', '--help',              'display this help message']
  ['-v', '--version',           'display the version number']
]

opts         = {}
sources      = []
optionParser = null


exports.run = ->
  parseOptions()
  return usage()                         if opts.help
  return version()                       if opts.version
  return unless opts.execute
  literals = if opts.run then sources.splice 1 else []

  # The magic... Creates an instance of Kckr, and then sets a callback.
  # Runs the command you specified on the command line.
  k = new kckr.Kckr sources, (source) ->
    doit = yes
    if opts.pattern
      doit = no
      re = new RegExp(opts.pattern)
      if source.match re
        doit = yes
    if doit
      basename = path.basename source
      basename_noext = basename.replace path.extname(basename), ''
      dirname = path.dirname source
      cmd = opts.execute.replace "{source}", source
      cmd = cmd.replace "{basename}", basename
      cmd = cmd.replace "{basename_noext}", basename_noext
      cmd = cmd.replace "{dirname}", dirname
      cmd = cmd.replace "{}", source
      exec cmd, (err, stdo, stde) ->
        if err
          timeLog "There was an error while running `#{ cmd }`."
          print_line "BEGIN ERROR\n#{ stdo }\n#{ stde }\nEND ERROR"
        else
          timeLog "<- `#{ cmd }`"
          for line in (l for l in stdo.split "\n" when l isnt '')
            timeLog "-> #{ line }"
          for line in (l for l in stde.split "\n" when l isnt '')
            timeLog "-> #{ line }"

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
