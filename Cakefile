path          = require 'path'
kckr          = require './lib/kckr/kckr'
{spawn, exec} = require 'child_process'

task 'watch', 'watches the folders, and builds', ->
  k = new kckr.Kckr ['src/lib', 'src/bin'], (source, base) ->
    dirname = path.basename base
    cmd = "coffee -c -o #{ dirname } #{ source }"
    console.log cmd
    exec cmd, (err) ->
      if err
        console.log "there was a prob."
      else
        console.log "success"

task 'build', 'builds the shit', ->
  exec 'coffee -clo ./lib src/lib', (err, stdo, stde) ->
    console.log "There was an error in the build\nBEGIN ERROR:\n#{ stdo }\nEND ERROR" if err?
    return if err?
    exec 'cp src/bin/kckr bin/ && chmod +x bin/kckr', (err, stdo, stde) ->
      console.log "Something went wrong with copying bin/kckr." if err?
      return if err?
      console.log "\n\tbuild successful!\n"
