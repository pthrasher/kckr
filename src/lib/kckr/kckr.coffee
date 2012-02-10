###
Technique kind of copied from coffee-script's CLI app. Their's works very well.
###

fs             = require 'fs'
path           = require 'path'
helpers        = require './helpers'

exports.VERSION = '1.0.1'

# Convenience for cleaner setTimeouts.
wait = (milliseconds, func) -> setTimeout func, milliseconds

class Kckr
  constructor: (paths, callback, verbose = no) ->
    @sources = (@validate p for p in paths)
    @not_sources = []
    @fn = callback
    @verbose = verbose

    # Start the cascade.
    @kickoff source, yes, (path.normalize source), yes for source in @sources

  validate: (source) ->
    return source

  kickoff: (source, top_level, base, first_run = no) =>
    fs.stat source, (err, stats) =>
      throw err if err and err.code isnt 'ENOENT'
      return if err?.code is 'ENOENT'
      if stats.isDirectory()
        @watch_dir source, base
        console.log "Watching dir: #{ source }" if first_run and @verbose
        fs.readdir source, (err, files) =>
          throw err if err and err.code isnt 'ENOENT'
          return if err?.code is 'ENOENT'
          files = files.map (file) -> path.join source, file
          index = @sources.indexOf source
          @sources[index..index] = files
          @kickoff file, no, base, yes for file in files
      else if top_level or stats.isFile()
        @watch source, base
        fs.readFile source, (err, code) =>
          throw err if err and err.code isnt 'ENOENT'
          return if err?.code is 'ENOENT'
          console.log "Watching file: #{ source }" if first_run and @verbose
      else
        @not_sources[source] = yes
        @remove_source source, base

  watch: (source, base) =>
    prev_stats = null
    cb_timeout = null

    watch_err = (e) =>
      if e.code is 'ENOENT'
        return if @sources.indexOf(source) is -1
        try
          rewatch()
          execute()
        catch e
          @remove_source source, base, yes
      else throw e

    execute = =>
      clearTimeout cb_timeout
      cb_timeout = wait 25, =>
        fs.stat source, (err, stats) =>
          return watch_err err if err
          return rewatch() if prev_stats and stats.size is prev_stats.size and
            stats.mtime.getTime() is prev_stats.mtime.getTime()
          prev_stats = stats
          @fn(source, base)
          rewatch()
    try
      watcher = fs.watch source, execute
    catch e
      watch_err e

    rewatch = =>
      watcher?.close()
      watcher = fs.watch source, execute

  watch_dir: (source, base) =>
    readdir_timeout = null
    try
      watcher = fs.watch source, ->
        clearTimeout readdir_timeout
        readdir_timeout = wait 25, ->
          fs.readdir source, (err, files) ->
            if err
              throw err unless err.code is 'ENOENT'
              watcher.close()
              return @unwatch_dir source, base
            files = files.map (file) -> path.join source, file
            for file in files
              continue if @sources.some (s) -> s.indexOf(file) >= 0
              sources.push file
              @kickoff file, no, base
    catch e
      throw e unless e.code is 'ENOENT'

  unwatch_dir: (source, base) =>
    prev_sources = @sources[0...@sources.length]
    to_remove = (file for file in sources when file.indexOf(source) >= 0)
    remove_source file, base, yes for file in to_remove
    return unless @sources.some (s, i) -> prev_sources[i] isnt s

  remove_source: (source, base) =>
    index = @sources.indexOf source
    @sources.splice index, 1

exports.Kckr = Kckr
