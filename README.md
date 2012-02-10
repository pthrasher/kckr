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

    kckr -e "lessc {source} > static/css/{basename_noext}.css" -r ".*\.less" static/less


get in touch
============
http://twitter.com/#!pthrasher
http://philipthrasher.com

or

philipthrasher[at) gmail (dot]com
