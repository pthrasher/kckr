(function() {
  var BANNER, SWITCHES, exec, fs, helpers, kckr, optionParser, optparse, opts, parseOptions, path, print_line, print_warn, sources, spawn, timeLog, usage, version, _ref;

  fs = require('fs');

  path = require('path');

  helpers = require('./helpers');

  optparse = require('./optparse');

  kckr = require('./kckr');

  _ref = require('child_process'), spawn = _ref.spawn, exec = _ref.exec;

  print_line = function(line) {
    return process.stdout.write(line + '\n');
  };

  print_warn = function(line) {
    return process.stderr.write(line + '\n');
  };

  BANNER = 'Usage: kckr [options] path/to/watch\n';

  SWITCHES = [['-e', '--execute [CMD]', 'cmd to execute upon file change. use {} for path placeholder.'], ['-p', '--path', 'path to dir, or file to watch.'], ['-r', '--pattern [PATTERN]', 'pattern for filenames to match if watching a dir.'], ['-h', '--help', 'display this help message'], ['-v', '--version', 'display the version number']];

  opts = {};

  sources = [];

  optionParser = null;

  exports.run = function() {
    var k, literals;
    parseOptions();
    if (opts.help) return usage();
    if (opts.version) return version();
    if (!opts.execute) return;
    literals = opts.run ? sources.splice(1) : [];
    return k = new kckr.Kckr(sources, function(source) {
      var basename, basename_noext, cmd, dirname, doit, re;
      doit = true;
      if (opts.pattern) {
        doit = false;
        re = new RegExp(opts.pattern);
        if (source.match(re)) doit = true;
      }
      if (doit) {
        basename = path.basename(source);
        basename_noext = basename.replace(path.extname(basename), '');
        dirname = path.dirname(source);
        cmd = opts.execute.replace("{source}", source);
        cmd = cmd.replace("{basename}", basename);
        cmd = cmd.replace("{basename_noext}", basename_noext);
        cmd = cmd.replace("{dirname}", dirname);
        cmd = cmd.replace("{}", source);
        return exec(cmd, function(err, stdo, stde) {
          var l, line, _i, _j, _len, _len2, _ref2, _ref3, _results;
          if (err) {
            timeLog("There was an error while running `" + cmd + "`.");
            return print_line("BEGIN ERROR\n" + stde + "\nEND ERROR");
          } else {
            timeLog("<- `" + cmd + "`");
            _ref2 = (function() {
              var _j, _len, _ref2, _results;
              _ref2 = stdo.split("\n");
              _results = [];
              for (_j = 0, _len = _ref2.length; _j < _len; _j++) {
                l = _ref2[_j];
                if (l !== '') _results.push(l);
              }
              return _results;
            })();
            for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
              line = _ref2[_i];
              timeLog("-> " + line);
            }
            _ref3 = (function() {
              var _k, _len2, _ref3, _results2;
              _ref3 = stde.split("\n");
              _results2 = [];
              for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
                l = _ref3[_k];
                if (l !== '') _results2.push(l);
              }
              return _results2;
            })();
            _results = [];
            for (_j = 0, _len2 = _ref3.length; _j < _len2; _j++) {
              line = _ref3[_j];
              _results.push(timeLog("-> " + line));
            }
            return _results;
          }
        });
      }
    });
  };

  parseOptions = function() {
    var o;
    optionParser = new optparse.OptionParser(SWITCHES, BANNER);
    o = opts = optionParser.parse(process.argv.slice(2));
    sources = o.arguments;
  };

  usage = function() {
    return print_line((new optparse.OptionParser(SWITCHES, BANNER)).help());
  };

  version = function() {
    return print_line("Kckr version " + kckr.VERSION);
  };

  timeLog = function(message) {
    return print_line("" + ((new Date).toLocaleTimeString()) + " - " + message);
  };

}).call(this);
