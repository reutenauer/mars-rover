The Mars robot interface.

Main code in directory src, tests in spec.

Written in fairly standard Ruby (tested with 2.1); it should be enough to run
`bundle` in the top-level directory, then `rspec` to run the tests.

Standalone executable in bin/run; can read the instruction either from file(s)
specified as argument(s) to the script, or from the standard input; but beware
of carriage returns when typing on the standard input.

TODO: full coverage

Copyright (c) Arthur Reutenauer, MIT/X11 licence, 30 April - 2 May 2014.
BachoTeX, Kujawsko-Pomorskie Voivodeship, Poland.
