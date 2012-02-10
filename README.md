kckr
====

[![Build Status](https://secure.travis-ci.org/pthrasher/kckr.png)](http://travis-ci.org/pthrasher/kckr)

what is it?
-----------

Kicker, watchr, live reload... There's a million and one scripts out there that
will take an action when files you're watching have changed. Kckr just actually
works. It would appear as though all of the others have fatal bugs. Mine
requires node, but just works out of the box afterward, damnit!

Also, I should say that I shamelessly took the technique from CoffeeScript's
command line app. They got it right, and they're the only ones I know of that
have a watcher that works reliably.

installing
----------

First, you need node.js, and npm. Once you got that part down, do the following.

    npm install -g kckr

how do I use it?
----------------

The help output says:

  Usage: kckr [options] path/to/watch


    -e, --execute      cmd to execute upon file change. use {}, {source}, {basename}, {basename_noext}, {dirname} for path placeholder(s).
    -k, --kickonce     just traverse the dir, exec on each match, and quit. don't do any watching, just do the kicking. (used in my `make build` -- check it out!)
    -p, --path         path to dir, or file to watch.
    -r, --pattern      pattern for filenames to match if watching a dir.
    -h, --help         display this help message
    -v, --version      display the version number

So, if you want to compile less css files from one dir into another dir on every file change and your directory structure looked like this:

    static/
      |->  less
      +->  css

You could do this:

    kckr -e "lessc {source} > static/css/{basename_noext}.css" -r ".*\.less" static

Got it? Maybe not? read it a few more times...

checkout the `watch` portion of the make file to see how I build my coffeescript while editing.

**tokens**

    {}, {source} - full relative path to file with extension. (ex. static/less/styles.less)
    {basename} - just the filename.  (ex. styles.less)
    {basename_noext} - Just the filename, sans extension. (ex. styles)
    {dirname} - everything but the filename. (ex. static/less/)
    {nobase} - source sans the starting dir. (ex. less/styles.less)
    {nobase_noext} - source sans the starting dir, sans the extension. (ex. less/styles)

get in touch
------------

http://twitter.com/#!philipthrasher

http://philipthrasher.com

or

philipthrasher[at) gmail (dot]com
