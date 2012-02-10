what is it?
===========

Kicker, watchr, live reload... There's a million and one scripts out there that
will take an action when files you're watching have changed. Kckr just actually
works. It would appear as though all of the others have fatal bugs. Mine
requires node, but just works out of the box afterward, damnit!

Also, I should say that I shamelessly took the technique from CoffeeScript's
command line app. They got it right, and they're the only ones I know of that
have a watcher that works reliably.


how do I use it?
================

The help output says:

  Usage: kckr [options] path/to/watch


    -e, --execute      cmd to execute upon file change. use {}, {source}, {basename}, {basename_noext}, {dirname} for path placeholder(s).
    -p, --path         path to dir, or file to watch.
    -r, --pattern      pattern for filenames to match if watching a dir.
    -h, --help         display this help message
    -v, --version      display the version number

So, if you want to compile less css files from one dir into another dir on every file change:

    kckr -e "lessc {source} > css/{basename_noext}.css" -r ".*\.less" less

Got it? Maybe not? read it a few more times...

Tokens
------

    {}, {source} - full relative path to file with extension.
    {basename} - Just the filename.
    {basename_noext} - Just the filename, sans extension.
    {dirname} - everything but the filename.

get in touch
============

http://twitter.com/#!pthrasher

http://philipthrasher.com

or

philipthrasher[at) gmail (dot]com
