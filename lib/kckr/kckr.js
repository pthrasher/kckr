
/*
Technique kind of copied from coffee-script's CLI app. Their's works very well.
*/

(function() {
  var Kckr, fs, helpers, path, wait,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  fs = require('fs');

  path = require('path');

  helpers = require('./helpers');

  exports.VERSION = '1.0.1';

  wait = function(milliseconds, func) {
    return setTimeout(func, milliseconds);
  };

  Kckr = (function() {

    function Kckr(paths, callback, verbose) {
      var p, source, _i, _len, _ref;
      if (verbose == null) verbose = false;
      this.remove_source = __bind(this.remove_source, this);
      this.unwatch_dir = __bind(this.unwatch_dir, this);
      this.watch_dir = __bind(this.watch_dir, this);
      this.watch = __bind(this.watch, this);
      this.kickoff = __bind(this.kickoff, this);
      this.sources = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = paths.length; _i < _len; _i++) {
          p = paths[_i];
          _results.push(this.validate(p));
        }
        return _results;
      }).call(this);
      this.not_sources = [];
      this.fn = callback;
      this.verbose = verbose;
      _ref = this.sources;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        source = _ref[_i];
        this.kickoff(source, true, path.normalize(source), true);
      }
    }

    Kckr.prototype.validate = function(source) {
      return source;
    };

    Kckr.prototype.kickoff = function(source, top_level, base, first_run) {
      var _this = this;
      if (first_run == null) first_run = false;
      return fs.stat(source, function(err, stats) {
        if (err && err.code !== 'ENOENT') throw err;
        if ((err != null ? err.code : void 0) === 'ENOENT') return;
        if (stats.isDirectory()) {
          _this.watch_dir(source, base);
          if (first_run && _this.verbose) console.log("Watching dir: " + source);
          return fs.readdir(source, function(err, files) {
            var file, index, _i, _len, _results;
            if (err && err.code !== 'ENOENT') throw err;
            if ((err != null ? err.code : void 0) === 'ENOENT') return;
            files = files.map(function(file) {
              return path.join(source, file);
            });
            index = _this.sources.indexOf(source);
            [].splice.apply(_this.sources, [index, index - index + 1].concat(files)), files;
            _results = [];
            for (_i = 0, _len = files.length; _i < _len; _i++) {
              file = files[_i];
              _results.push(_this.kickoff(file, false, base, true));
            }
            return _results;
          });
        } else if (top_level || stats.isFile()) {
          _this.watch(source, base);
          return fs.readFile(source, function(err, code) {
            if (err && err.code !== 'ENOENT') throw err;
            if ((err != null ? err.code : void 0) === 'ENOENT') return;
            if (first_run && _this.verbose) {
              return console.log("Watching file: " + source);
            }
          });
        } else {
          _this.not_sources[source] = true;
          return _this.remove_source(source, base);
        }
      });
    };

    Kckr.prototype.watch = function(source, base) {
      var cb_timeout, execute, prev_stats, rewatch, watch_err, watcher,
        _this = this;
      prev_stats = null;
      cb_timeout = null;
      watch_err = function(e) {
        if (e.code === 'ENOENT') {
          if (_this.sources.indexOf(source) === -1) return;
          try {
            rewatch();
            return execute();
          } catch (e) {
            return _this.remove_source(source, base, true);
          }
        } else {
          throw e;
        }
      };
      execute = function() {
        clearTimeout(cb_timeout);
        return cb_timeout = wait(25, function() {
          return fs.stat(source, function(err, stats) {
            if (err) return watch_err(err);
            if (prev_stats && stats.size === prev_stats.size && stats.mtime.getTime() === prev_stats.mtime.getTime()) {
              return rewatch();
            }
            prev_stats = stats;
            _this.fn(source, base);
            return rewatch();
          });
        });
      };
      try {
        watcher = fs.watch(source, execute);
      } catch (e) {
        watch_err(e);
      }
      return rewatch = function() {
        if (watcher != null) watcher.close();
        return watcher = fs.watch(source, execute);
      };
    };

    Kckr.prototype.watch_dir = function(source, base) {
      var readdir_timeout, watcher;
      readdir_timeout = null;
      try {
        return watcher = fs.watch(source, function() {
          clearTimeout(readdir_timeout);
          return readdir_timeout = wait(25, function() {
            return fs.readdir(source, function(err, files) {
              var file, _i, _len, _results;
              if (err) {
                if (err.code !== 'ENOENT') throw err;
                watcher.close();
                return this.unwatch_dir(source, base);
              }
              files = files.map(function(file) {
                return path.join(source, file);
              });
              _results = [];
              for (_i = 0, _len = files.length; _i < _len; _i++) {
                file = files[_i];
                if (this.sources.some(function(s) {
                  return s.indexOf(file) >= 0;
                })) {
                  continue;
                }
                sources.push(file);
                _results.push(this.kickoff(file, false, base));
              }
              return _results;
            });
          });
        });
      } catch (e) {
        if (e.code !== 'ENOENT') throw e;
      }
    };

    Kckr.prototype.unwatch_dir = function(source, base) {
      var file, prev_sources, to_remove, _i, _len;
      prev_sources = this.sources.slice(0, this.sources.length);
      to_remove = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = sources.length; _i < _len; _i++) {
          file = sources[_i];
          if (file.indexOf(source) >= 0) _results.push(file);
        }
        return _results;
      })();
      for (_i = 0, _len = to_remove.length; _i < _len; _i++) {
        file = to_remove[_i];
        remove_source(file, base, true);
      }
      if (!this.sources.some(function(s, i) {
        return prev_sources[i] !== s;
      })) {}
    };

    Kckr.prototype.remove_source = function(source, base) {
      var index;
      index = this.sources.indexOf(source);
      return this.sources.splice(index, 1);
    };

    return Kckr;

  })();

  exports.Kckr = Kckr;

}).call(this);
